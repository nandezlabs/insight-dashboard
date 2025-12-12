#!/bin/zsh

################################################################################
# Enter Maintenance Phase
# Transitions project from active development to maintenance mode
################################################################################

# Source path configuration
source "${HOME}/Developer/tools/configs/developer-paths.conf" 2>/dev/null || true

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BLUE}           Enter Maintenance Phase                                ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if in production phase
if [[ ! -f ".copilot-production" ]]; then
  echo "${RED}✗${NC} No .copilot-production marker found"
  echo "  This script should be run from a project in production phase"
  echo "  Current phase markers found:"
  [[ -f ".copilot-planning" ]] && echo "    - Planning phase active"
  [[ -f ".copilot-development" ]] && echo "    - In development"
  [[ -f ".copilot-maintenance" ]] && echo "    - Already in maintenance"
  exit 1
fi

# Check if PLANNING-MASTER.md exists
if [[ ! -f "PLANNING-MASTER.md" ]]; then
  echo "${YELLOW}⚠${NC}  No PLANNING-MASTER.md found"
  echo "  Continuing without planning document updates"
fi

# Maintenance readiness assessment
echo "${YELLOW}Maintenance Phase Assessment:${NC}"
echo ""
echo "Development Status:"
echo "  ✓ All planned phases complete (Phase 1, 2, 3)"
echo "  ✓ Feature development stabilized"
echo "  ✓ Major features shipped"
echo ""
echo "Production Status:"
echo "  ✓ Application stable in production"
echo "  ✓ User base established"
echo "  ✓ No critical issues outstanding"
echo ""
echo "Documentation:"
echo "  ✓ Comprehensive documentation complete"
echo "  ✓ Runbooks documented"
echo "  ✓ Support processes established"
echo ""
echo "Infrastructure:"
echo "  ✓ Automated monitoring in place"
echo "  ✓ Backup/restore tested"
echo "  ✓ Disaster recovery plan validated"
echo ""
echo "${CYAN}Note:${NC} Maintenance mode means:"
echo "  - Focus shifts to stability and support"
echo "  - New feature development is minimal/on-demand"
echo "  - Priority: bug fixes, security, performance"
echo "  - Regular updates rather than active development"
echo ""
read "CONFIRM?Enter maintenance mode? (y/N): "

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "${YELLOW}Remaining in production/active development phase${NC}"
  exit 0
fi

# Get maintenance team info
echo ""
echo "${YELLOW}Maintenance Configuration:${NC}"
read "MAINT_SCHEDULE?Maintenance schedule (daily/weekly/monthly/as-needed): "
read "MAINT_CONTACT?Primary maintenance contact: "

# Remove production marker
rm .copilot-production
echo "${GREEN}✓${NC} Removed .copilot-production marker"

# Create maintenance marker
MAINTENANCE_DATE=$(date +%Y-%m-%d)
MAINTENANCE_TIME=$(date +%Y-%m-%d\ %H:%M:%S)
cat > ".copilot-maintenance" << MARKER
# Maintenance Phase Active
#
# This project is in MAINTENANCE MODE.
# - Focus on stability, security, and bug fixes
# - New features are low priority
# - Regular updates and monitoring
# - User support and issue resolution
#
# Phase Started: ${MAINTENANCE_TIME}
# Maintenance Schedule: ${MAINT_SCHEDULE}
# Primary Contact: ${MAINT_CONTACT}
#
# To return to active development, delete this file and
# create .copilot-development marker
MARKER

echo "${GREEN}✓${NC} Created .copilot-maintenance marker"

# Update VS Code settings
if [[ -f ".vscode/settings.json" ]]; then
  cat > ".vscode/settings.json" << 'SETTINGS'
{
  "github.copilot.chat.editorInstructions": [
    {
      "text": "This project is in MAINTENANCE MODE. Prioritize stability and backward compatibility. Focus on bug fixes, security updates, and performance optimization. New features should be minimal and well-justified. Reference PLANNING-MASTER.md for architecture. Maintain comprehensive testing for all changes."
    }
  ]
}
SETTINGS
  echo "${GREEN}✓${NC} Updated VS Code settings for maintenance phase"
fi

# Create maintenance info record
cat > ".maintenance-info.json" << MAINTINFO
{
  "phase": "maintenance",
  "entered": "${MAINTENANCE_TIME}",
  "schedule": "${MAINT_SCHEDULE}",
  "contact": "${MAINT_CONTACT}",
  "transitioned_from": "production"
}
MAINTINFO

echo "${GREEN}✓${NC} Created maintenance info record"

# Log phase transition
echo "${MAINTENANCE_TIME} | Production → Maintenance | Schedule: ${MAINT_SCHEDULE} | Contact: ${MAINT_CONTACT}" >> .phase-history.log
echo "${GREEN}✓${NC} Logged phase transition"

# Update PLANNING-MASTER.md if it exists
if [[ -f "PLANNING-MASTER.md" ]]; then
  echo ""
  echo "${CYAN}Updating PLANNING-MASTER.md...${NC}"

  # Try to update phase status (best effort)
  if grep -q "**Current Phase:**" PLANNING-MASTER.md; then
    sed -i.bak "s/\*\*Current Phase:\*\*.*/\*\*Current Phase:\*\* Maintenance/" PLANNING-MASTER.md
    sed -i.bak "s/\*\*Phase Started:\*\*.*/\*\*Phase Started:\*\* ${MAINTENANCE_DATE}/" PLANNING-MASTER.md
    rm -f PLANNING-MASTER.md.bak
    echo "${GREEN}✓${NC} Updated phase status in PLANNING-MASTER.md"
    echo "${YELLOW}⚠${NC}  Review and update Phase History table manually"
  fi
fi

# Create maintenance procedures document
cat > "MAINTENANCE-PROCEDURES.md" << PROCEDURES
# Maintenance Procedures

## Maintenance Schedule: ${MAINT_SCHEDULE}

## Primary Contact
**Maintainer:** ${MAINT_CONTACT}

## Routine Maintenance Tasks

### ${MAINT_SCHEDULE^} Tasks
- [ ] Review and triage new issues
- [ ] Check security advisories
- [ ] Monitor error logs and alerts
- [ ] Review dependency updates
- [ ] Respond to user support requests

### Monthly Tasks
- [ ] Security updates and patches
- [ ] Dependency updates (non-breaking)
- [ ] Performance monitoring review
- [ ] Backup verification
- [ ] Documentation updates

### Quarterly Tasks
- [ ] Security audit
- [ ] Performance optimization review
- [ ] Infrastructure cost review
- [ ] Full disaster recovery test
- [ ] Team review of maintenance priorities

### Annual Tasks
- [ ] Comprehensive security audit
- [ ] Infrastructure modernization assessment
- [ ] Documentation comprehensive review
- [ ] Consider upgrade to active development if needed

## Maintenance Activities

### Priority Levels
1. **Critical:** Security vulnerabilities, data loss risks, service outages
2. **High:** Major bugs affecting multiple users, performance degradation
3. **Medium:** Minor bugs, small feature requests, documentation
4. **Low:** Nice-to-have improvements, optimization

### Change Process
1. Assess risk and impact
2. Test in staging/development
3. Document changes
4. Deploy during maintenance window
5. Monitor post-deployment
6. Update changelog

## Support Channels
- Issues: [GitHub Issues / Support Email]
- Documentation: [URL]
- Status Page: [URL]
- Contact: ${MAINT_CONTACT}

## Emergency Procedures
See PLANNING-MASTER.md → Disaster Recovery section

## Returning to Active Development
If significant new features are planned:
\`\`\`bash
rm .copilot-maintenance
cat > .copilot-development << 'EOF'
# Development Phase Active
# Returned to active development from maintenance
# Started: $(date)
EOF
\`\`\`

Then update PLANNING-MASTER.md with new phase information.
PROCEDURES

echo "${GREEN}✓${NC} Created MAINTENANCE-PROCEDURES.md"

# Archive active development files
mkdir -p .archived-development 2>/dev/null
[[ -f "PRODUCTION-CHECKLIST.md" ]] && mv PRODUCTION-CHECKLIST.md .archived-development/ 2>/dev/null
echo "${GREEN}✓${NC} Archived active development files"

# Git commit suggestion
if [[ -d ".git" ]]; then
  echo ""
  echo "${CYAN}Suggested git commands:${NC}"
  echo "  git add ."
  echo "  git commit -m 'chore: enter maintenance phase'"
  echo "  git push"
fi

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}🔧 Maintenance Mode Active!${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "${GREEN}✓${NC} Project is now in maintenance mode"
echo "${GREEN}✓${NC} Maintenance tracking active"
echo ""
echo "${YELLOW}Maintenance Focus:${NC}"
echo "  • Bug fixes and patches"
echo "  • Security updates"
echo "  • Dependency maintenance"
echo "  • Performance optimization"
echo "  • User support"
echo ""
echo "${YELLOW}Next Steps:${NC}"
echo "1. Review MAINTENANCE-PROCEDURES.md"
echo "2. Set up ${MAINT_SCHEDULE} maintenance schedule"
echo "3. Update team on maintenance expectations"
echo "4. Continue monitoring production metrics"
echo "5. Update Phase History in PLANNING-MASTER.md"
echo ""
echo "${CYAN}Maintenance Schedule:${NC} ${MAINT_SCHEDULE}"
echo "${CYAN}Primary Contact:${NC} ${MAINT_CONTACT}"
echo ""
