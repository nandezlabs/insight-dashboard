#!/bin/bash

################################################################################
# Database Maintainer
# Database backups, optimizations, and health checks
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
BACKUP_ROOT="$HOME/Developer/backups/databases"
MAX_BACKUPS=10

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🗄️  Database Maintainer${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

################################################################################
# PostgreSQL
################################################################################

check_postgres() {
    if ! command -v psql &> /dev/null; then
        print_warning "PostgreSQL not installed"
        return 1
    fi
    
    if ! lsof -i :5432 &> /dev/null; then
        print_warning "PostgreSQL not running"
        return 1
    fi
    
    print_success "PostgreSQL is running"
    return 0
}

list_postgres_databases() {
    print_info "PostgreSQL databases:\n"
    
    psql -U postgres -l -t | awk '{print $1}' | grep -v "^$" | grep -v "template" | grep -v "|" | \
        while read -r db; do
            [[ -z "$db" ]] && continue
            local size=$(psql -U postgres -d "$db" -c "SELECT pg_size_pretty(pg_database_size('$db'));" -t 2>/dev/null | tr -d ' ')
            echo "  $db ($size)"
        done
}

backup_postgres_database() {
    local db_name="$1"
    local username="${2:-postgres}"
    
    if [[ -z "$db_name" ]]; then
        print_error "Database name required"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$BACKUP_ROOT/postgres/$db_name"
    local backup_file="$backup_dir/${db_name}_${timestamp}.sql"
    
    mkdir -p "$backup_dir"
    
    print_info "Backing up PostgreSQL database: $db_name"
    
    if pg_dump -U "$username" "$db_name" > "$backup_file"; then
        # Compress the backup
        gzip "$backup_file"
        
        local size=$(du -h "${backup_file}.gz" | awk '{print $1}')
        print_success "Backup created: ${backup_file}.gz ($size)"
        
        # Rotate old backups
        rotate_db_backups "$backup_dir"
    else
        print_error "Backup failed"
        return 1
    fi
}

backup_all_postgres() {
    if ! check_postgres; then
        return 1
    fi
    
    print_info "Backing up all PostgreSQL databases...\n"
    
    local databases=$(psql -U postgres -l -t | awk '{print $1}' | grep -v "^$" | grep -v "template" | grep -v "|")
    
    for db in $databases; do
        [[ -z "$db" ]] && continue
        backup_postgres_database "$db"
        echo ""
    done
    
    print_success "All PostgreSQL databases backed up"
}

restore_postgres_database() {
    local backup_file="$1"
    local db_name="$2"
    local username="${3:-postgres}"
    
    if [[ ! -f "$backup_file" ]]; then
        print_error "Backup file not found: $backup_file"
        return 1
    fi
    
    if [[ -z "$db_name" ]]; then
        print_error "Database name required"
        return 1
    fi
    
    print_warning "This will restore: $(basename "$backup_file")"
    print_warning "To database: $db_name"
    read -p "Continue? (y/n): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        return 0
    fi
    
    print_info "Restoring database..."
    
    # Check if compressed
    if [[ "$backup_file" == *.gz ]]; then
        if gunzip -c "$backup_file" | psql -U "$username" "$db_name"; then
            print_success "Database restored"
        else
            print_error "Restore failed"
            return 1
        fi
    else
        if psql -U "$username" "$db_name" < "$backup_file"; then
            print_success "Database restored"
        else
            print_error "Restore failed"
            return 1
        fi
    fi
}

optimize_postgres_database() {
    local db_name="$1"
    local username="${2:-postgres}"
    
    print_info "Optimizing PostgreSQL database: $db_name"
    
    # Vacuum and analyze
    if psql -U "$username" -d "$db_name" -c "VACUUM ANALYZE;"; then
        print_success "Database optimized"
    else
        print_error "Optimization failed"
        return 1
    fi
}

################################################################################
# MongoDB
################################################################################

check_mongo() {
    if ! command -v mongosh &> /dev/null && ! command -v mongo &> /dev/null; then
        print_warning "MongoDB client not installed"
        return 1
    fi
    
    if ! lsof -i :27017 &> /dev/null; then
        print_warning "MongoDB not running"
        return 1
    fi
    
    print_success "MongoDB is running"
    return 0
}

list_mongo_databases() {
    print_info "MongoDB databases:\n"
    
    local mongo_cmd="mongo"
    if command -v mongosh &> /dev/null; then
        mongo_cmd="mongosh"
    fi
    
    $mongo_cmd --quiet --eval "db.adminCommand('listDatabases').databases.forEach(function(d) { print(d.name + ' (' + (d.sizeOnDisk / 1024 / 1024).toFixed(2) + ' MB)'); })" 2>/dev/null | \
        while read -r line; do
            echo "  $line"
        done
}

backup_mongo_database() {
    local db_name="$1"
    
    if [[ -z "$db_name" ]]; then
        print_error "Database name required"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$BACKUP_ROOT/mongodb/$db_name"
    local backup_path="$backup_dir/${db_name}_${timestamp}"
    
    mkdir -p "$backup_dir"
    
    print_info "Backing up MongoDB database: $db_name"
    
    if mongodump --db "$db_name" --out "$backup_path" &> /dev/null; then
        # Compress the backup
        tar czf "${backup_path}.tar.gz" -C "$backup_dir" "$(basename "$backup_path")"
        rm -rf "$backup_path"
        
        local size=$(du -h "${backup_path}.tar.gz" | awk '{print $1}')
        print_success "Backup created: ${backup_path}.tar.gz ($size)"
        
        # Rotate old backups
        rotate_db_backups "$backup_dir"
    else
        print_error "Backup failed"
        return 1
    fi
}

backup_all_mongo() {
    if ! check_mongo; then
        return 1
    fi
    
    print_info "Backing up all MongoDB databases...\n"
    
    local mongo_cmd="mongo"
    if command -v mongosh &> /dev/null; then
        mongo_cmd="mongosh"
    fi
    
    local databases=$($mongo_cmd --quiet --eval "db.adminCommand('listDatabases').databases.forEach(function(d) { print(d.name); })" 2>/dev/null)
    
    for db in $databases; do
        [[ "$db" == "admin" || "$db" == "config" || "$db" == "local" ]] && continue
        backup_mongo_database "$db"
        echo ""
    done
    
    print_success "All MongoDB databases backed up"
}

restore_mongo_database() {
    local backup_file="$1"
    local db_name="$2"
    
    if [[ ! -f "$backup_file" ]]; then
        print_error "Backup file not found: $backup_file"
        return 1
    fi
    
    if [[ -z "$db_name" ]]; then
        print_error "Database name required"
        return 1
    fi
    
    print_warning "This will restore: $(basename "$backup_file")"
    print_warning "To database: $db_name"
    read -p "Continue? (y/n): " confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Cancelled"
        return 0
    fi
    
    print_info "Restoring database..."
    
    # Extract if compressed
    local temp_dir="/tmp/mongo_restore_$$"
    mkdir -p "$temp_dir"
    
    if [[ "$backup_file" == *.tar.gz ]]; then
        tar xzf "$backup_file" -C "$temp_dir"
        
        if mongorestore --db "$db_name" "$temp_dir"/*; then
            print_success "Database restored"
        else
            print_error "Restore failed"
            rm -rf "$temp_dir"
            return 1
        fi
        
        rm -rf "$temp_dir"
    else
        print_error "Invalid backup format"
        return 1
    fi
}

################################################################################
# MySQL/MariaDB
################################################################################

check_mysql() {
    if ! command -v mysql &> /dev/null; then
        print_warning "MySQL/MariaDB not installed"
        return 1
    fi
    
    if ! lsof -i :3306 &> /dev/null; then
        print_warning "MySQL/MariaDB not running"
        return 1
    fi
    
    print_success "MySQL/MariaDB is running"
    return 0
}

list_mysql_databases() {
    print_info "MySQL/MariaDB databases:\n"
    
    mysql -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables GROUP BY table_schema;" | \
        tail -n +2 | \
        while read -r db size; do
            echo "  $db ($size MB)"
        done
}

backup_mysql_database() {
    local db_name="$1"
    local username="${2:-root}"
    
    if [[ -z "$db_name" ]]; then
        print_error "Database name required"
        return 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$BACKUP_ROOT/mysql/$db_name"
    local backup_file="$backup_dir/${db_name}_${timestamp}.sql"
    
    mkdir -p "$backup_dir"
    
    print_info "Backing up MySQL database: $db_name"
    
    if mysqldump -u "$username" -p "$db_name" > "$backup_file"; then
        # Compress the backup
        gzip "$backup_file"
        
        local size=$(du -h "${backup_file}.gz" | awk '{print $1}')
        print_success "Backup created: ${backup_file}.gz ($size)"
        
        # Rotate old backups
        rotate_db_backups "$backup_dir"
    else
        print_error "Backup failed"
        return 1
    fi
}

################################################################################
# Backup Management
################################################################################

rotate_db_backups() {
    local backup_dir="$1"
    
    # Count backups
    local count=$(find "$backup_dir" -maxdepth 1 -type f \( -name "*.sql.gz" -o -name "*.tar.gz" \) | wc -l | tr -d ' ')
    
    if [[ $count -gt $MAX_BACKUPS ]]; then
        local to_delete=$((count - MAX_BACKUPS))
        print_info "Rotating backups: removing $to_delete old backup(s)"
        
        # Delete oldest backups
        find "$backup_dir" -maxdepth 1 -type f \( -name "*.sql.gz" -o -name "*.tar.gz" \) -printf '%T+ %p\n' | \
            sort | \
            head -n "$to_delete" | \
            cut -d' ' -f2- | \
            while read -r file; do
                rm "$file"
                print_info "  Removed: $(basename "$file")"
            done
    fi
}

list_backups() {
    local db_type="$1"  # postgres, mongodb, mysql
    local db_name="$2"
    
    if [[ -n "$db_name" ]]; then
        local backup_dir="$BACKUP_ROOT/$db_type/$db_name"
        
        if [[ ! -d "$backup_dir" ]]; then
            print_warning "No backups found for: $db_name"
            return 1
        fi
        
        print_info "Backups for $db_name:\n"
        
        find "$backup_dir" -type f \( -name "*.sql.gz" -o -name "*.tar.gz" \) -printf '%T@ %p\n' | \
            sort -rn | \
            while read -r timestamp path; do
                local date=$(date -r "${timestamp%.*}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "unknown")
                local size=$(du -h "$path" | awk '{print $1}')
                local filename=$(basename "$path")
                echo "  $date - $filename ($size)"
            done
    else
        print_info "All database backups:\n"
        
        for db_type in postgres mongodb mysql; do
            local type_dir="$BACKUP_ROOT/$db_type"
            
            if [[ -d "$type_dir" ]]; then
                local count=$(find "$type_dir" -type f \( -name "*.sql.gz" -o -name "*.tar.gz" \) 2>/dev/null | wc -l | tr -d ' ')
                if [[ $count -gt 0 ]]; then
                    local total_size=$(du -sh "$type_dir" 2>/dev/null | awk '{print $1}')
                    echo "  $db_type: $count backup(s) ($total_size)"
                fi
            fi
        done
    fi
}

################################################################################
# Health Check
################################################################################

check_all_databases() {
    print_info "Database Status:\n"
    
    # PostgreSQL
    if check_postgres 2>/dev/null; then
        list_postgres_databases
    fi
    
    echo ""
    
    # MongoDB
    if check_mongo 2>/dev/null; then
        list_mongo_databases
    fi
    
    echo ""
    
    # MySQL
    if check_mysql 2>/dev/null; then
        list_mysql_databases
    fi
}

################################################################################
# Interactive Mode
################################################################################

interactive_mode() {
    echo -e "${CYAN}Database Maintenance Options:${NC}"
    echo "  1) Check database status"
    echo "  2) Backup PostgreSQL database"
    echo "  3) Backup MongoDB database"
    echo "  4) Backup MySQL database"
    echo "  5) Backup all databases"
    echo "  6) List backups"
    echo "  7) Restore database"
    echo "  8) Optimize PostgreSQL database"
    echo "  q) Quit"
    echo ""
    
    read -p "Selection: " choice
    
    case $choice in
        1)
            check_all_databases
            ;;
        2)
            if check_postgres; then
                list_postgres_databases
                echo ""
                read -p "Database name: " db_name
                backup_postgres_database "$db_name"
            fi
            ;;
        3)
            if check_mongo; then
                list_mongo_databases
                echo ""
                read -p "Database name: " db_name
                backup_mongo_database "$db_name"
            fi
            ;;
        4)
            if check_mysql; then
                list_mysql_databases
                echo ""
                read -p "Database name: " db_name
                backup_mysql_database "$db_name"
            fi
            ;;
        5)
            backup_all_postgres 2>/dev/null
            echo ""
            backup_all_mongo 2>/dev/null
            ;;
        6)
            read -p "Database type (postgres/mongodb/mysql, or leave empty for all): " db_type
            read -p "Database name (optional): " db_name
            list_backups "$db_type" "$db_name"
            ;;
        7)
            read -p "Backup file path: " backup_file
            read -p "Database name: " db_name
            read -p "Database type (postgres/mongodb/mysql): " db_type
            
            case $db_type in
                postgres)
                    restore_postgres_database "$backup_file" "$db_name"
                    ;;
                mongodb)
                    restore_mongo_database "$backup_file" "$db_name"
                    ;;
                *)
                    print_error "Unsupported database type"
                    ;;
            esac
            ;;
        8)
            if check_postgres; then
                list_postgres_databases
                echo ""
                read -p "Database name: " db_name
                optimize_postgres_database "$db_name"
            fi
            ;;
        q|Q)
            print_info "Exiting"
            exit 0
            ;;
        *)
            print_error "Invalid selection"
            exit 1
            ;;
    esac
}

################################################################################
# Main Function
################################################################################

show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  check                Check database status"
    echo "  backup-postgres DB   Backup PostgreSQL database"
    echo "  backup-mongo DB      Backup MongoDB database"
    echo "  backup-mysql DB      Backup MySQL database"
    echo "  backup-all           Backup all databases"
    echo "  list [TYPE] [DB]     List backups"
    echo "  restore FILE DB TYPE Restore database"
    echo "  optimize DB          Optimize PostgreSQL database"
    echo "  interactive          Interactive mode"
    echo ""
    echo "Examples:"
    echo "  $0 check"
    echo "  $0 backup-postgres mydb"
    echo "  $0 backup-all"
    echo "  $0 list postgres"
    echo "  $0 interactive"
}

main() {
    local command="${1:-interactive}"
    
    print_header
    
    mkdir -p "$BACKUP_ROOT"/{postgres,mongodb,mysql}
    
    case $command in
        check)
            check_all_databases
            ;;
        backup-postgres)
            if [[ -z "$2" ]]; then
                print_error "Database name required"
                show_usage
                exit 1
            fi
            backup_postgres_database "$2"
            ;;
        backup-mongo)
            if [[ -z "$2" ]]; then
                print_error "Database name required"
                show_usage
                exit 1
            fi
            backup_mongo_database "$2"
            ;;
        backup-mysql)
            if [[ -z "$2" ]]; then
                print_error "Database name required"
                show_usage
                exit 1
            fi
            backup_mysql_database "$2"
            ;;
        backup-all)
            backup_all_postgres 2>/dev/null || true
            echo ""
            backup_all_mongo 2>/dev/null || true
            ;;
        list)
            list_backups "$2" "$3"
            ;;
        restore)
            if [[ -z "$2" || -z "$3" || -z "$4" ]]; then
                print_error "Backup file, database name, and type required"
                show_usage
                exit 1
            fi
            
            case $4 in
                postgres)
                    restore_postgres_database "$2" "$3"
                    ;;
                mongodb)
                    restore_mongo_database "$2" "$3"
                    ;;
                *)
                    print_error "Unsupported database type: $4"
                    exit 1
                    ;;
            esac
            ;;
        optimize)
            if [[ -z "$2" ]]; then
                print_error "Database name required"
                show_usage
                exit 1
            fi
            optimize_postgres_database "$2"
            ;;
        interactive)
            interactive_mode
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
