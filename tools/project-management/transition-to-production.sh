#!/bin/zsh

################################################################################
# Transition to Production Phase
# Marks project as production-ready and updates phase tracking
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
echo "${BLUE}           Transition to Production Phase                         ${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if in development phase
if [[ ! -f ".copilot-development" ]]; then
  echo "${RED}✗${NC} No .copilot-development marker found"
  echo "  This script should be run from a project in development phase"
  echo "  Current phase markers found:"
  [[ -f ".copilot-planning" ]] && echo "    - Planning phase active"
  [[ -f ".copilot-production" ]] && echo "    - Already in production"
  [[ -f ".copilot-maintenance" ]] && echo "    - In maintenance mode"
  exit 1
fi

# Check if PLANNING-MASTER.md exists
if [[ ! -f "PLANNING-MASTER.md" ]]; then
  echo "${YELLOW}⚠${NC}  No PLANNING-MASTER.md found"
  echo "  Continuing without planning document updates"
fi

# Production readiness checklist
echo "${YELLOW}Production Readiness Checklist:${NC}"
echo ""
echo "MVP Features:"
echo "  ✓ All MVP features complete"
echo "  ✓ Critical bugs resolved"
echo "  ✓ User testing passed"
echo ""
echo "Quality Gates:"
echo "  ✓ Security audit passed"
echo "  ✓ Performance benchmarks met"
echo "  ✓ Test coverage adequate"
echo ""
echo "Infrastructure:"
echo "  ✓ Production environment ready"
echo "  ✓ Monitoring configured"
echo "  ✓ Backup strategy in place"
echo "  ✓ Rollback plan documented"
echo ""
echo "Documentation:"
echo "  ✓ User documentation complete"
echo "  ✓ API documentation complete"
echo "  ✓ Deployment guide complete"
echo ""
read "CONFIRM?Is the project ready for production? (y/N): "

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "${YELLOW}Continue development until ready${NC}"
  exit 0
fi

# Get deployment target
echo ""
echo "${YELLOW}Deployment Configuration:${NC}"
read "DEPLOY_TARGET?Primary deployment target (vercel/netlify/hostinger/docker/other): "
read "DEPLOY_URL?Production URL: "

# Remove development marker
rm .copilot-development
echo "${GREEN}✓${NC} Removed .copilot-development marker"

# Create production marker
PRODUCTION_DATE=$(date +%Y-%m-%d)
PRODUCTION_TIME=$(date +%Y-%m-%d\ %H:%M:%S)
cat > ".copilot-production" << MARKER
# Production Phase Active
#
# This project is in PRODUCTION.
# - Live users are depending on this application
# - Changes should go through staging first
# - Monitor production metrics carefully
# - Follow incident response procedures for issues
#
# Phase Started: ${PRODUCTION_TIME}
# Deployment Target: ${DEPLOY_TARGET}
# Production URL: ${DEPLOY_URL}
MARKER

echo "${GREEN}✓${NC} Created .copilot-production marker"

# Update VS Code settings
if [[ -f ".vscode/settings.json" ]]; then
  cat > ".vscode/settings.json" << 'SETTINGS'
{
  "github.copilot.chat.editorInstructions": [
    {
      "text": "This project is in PRODUCTION. Live users depend on this application. Reference PLANNING-MASTER.md for architecture. Be cautious with changes - suggest staging/testing for all modifications. Prioritize stability, security, and backward compatibility. Monitor production metrics."
    }
  ]
}
SETTINGS
  echo "${GREEN}✓${NC} Updated VS Code settings for production phase"
fi

# Create production deployment record
cat > ".production-info.json" << PRODINFO
{
  "phase": "production",
  "launched": "${PRODUCTION_TIME}",
  "target": "${DEPLOY_TARGET}",
  "url": "${DEPLOY_URL}",
  "version": "1.0.0",
  "transitioned_from": "development"
}
PRODINFO

echo "${GREEN}✓${NC} Created production deployment record"

# Log phase transition
echo "${PRODUCTION_TIME} | Development → Production | Target: ${DEPLOY_TARGET} | URL: ${DEPLOY_URL}" >> .phase-history.log
echo "${GREEN}✓${NC} Logged phase transition"

# Update PLANNING-MASTER.md if it exists
if [[ -f "PLANNING-MASTER.md" ]]; then
  echo ""
  echo "${CYAN}Updating PLANNING-MASTER.md...${NC}"

  # Try to update phase status (best effort)
  if grep -q "**Current Phase:**" PLANNING-MASTER.md; then
    sed -i.bak "s/\*\*Current Phase:\*\*.*/\*\*Current Phase:\*\* Production/" PLANNING-MASTER.md
    sed -i.bak "s/\*\*Phase Started:\*\*.*/\*\*Phase Started:\*\* ${PRODUCTION_DATE}/" PLANNING-MASTER.md
    rm -f PLANNING-MASTER.md.bak
    echo "${GREEN}✓${NC} Updated phase status in PLANNING-MASTER.md"
    echo "${YELLOW}⚠${NC}  Review and update Phase History table manually"
  fi
fi

# Create production monitoring reminder
cat > "PRODUCTION-CHECKLIST.md" << CHECKLIST
# Production Monitoring Checklist

## Daily Tasks
- [ ] Check error rates and alerts
- [ ] Review performance metrics
- [ ] Monitor user feedback channels
- [ ] Check server resource usage

## Weekly Tasks
- [ ] Review analytics and user engagement
- [ ] Check for security updates
- [ ] Review and prioritize user feedback
- [ ] Update team on production status

## Monthly Tasks
- [ ] Security scan and audit
- [ ] Performance optimization review
- [ ] Cost analysis and optimization
- [ ] Backup restoration test
- [ ] Review and update documentation

## Production URLs
- Production: ${DEPLOY_URL}
- Monitoring Dashboard: [Add URL]
- Error Tracking: [Add URL]
- Analytics: [Add URL]

## Incident Response
See PLANNING-MASTER.md → Disaster Recovery section for procedures.

## Next Phase
When feature development stabilizes and project enters maintenance mode:
\`\`\`bash
~/Developer/tools/project-management/enter-maintenance.sh
\`\`\`
CHECKLIST

echo "${GREEN}✓${NC} Created PRODUCTION-CHECKLIST.md"

# Git commit suggestion
if [[ -d ".git" ]]; then
  echo ""
  echo "${CYAN}Suggested git commands:${NC}"
  echo "  git add ."
  echo "  git commit -m 'chore: transition to production phase'"
  echo "  git tag v1.0.0"
  echo "  git push origin main --tags"
fi

echo ""
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${GREEN}🚀 Production Phase Active!${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "${GREEN}✓${NC} Project is now in production"
echo "${GREEN}✓${NC} Production tracking active"
echo ""
echo "${YELLOW}Next Steps:${NC}"
echo "1. Deploy to production: ${DEPLOY_TARGET}"
echo "2. Verify deployment at: ${DEPLOY_URL}"
echo "3. Monitor production metrics closely"
echo "4. Review PRODUCTION-CHECKLIST.md for daily tasks"
echo "5. Begin Phase 2 planning or continue feature development"
echo "6. Update Phase History in PLANNING-MASTER.md"
echo ""
echo "${CYAN}Production Monitoring:${NC}"
echo "  - Set up alerts for errors and performance"
echo "  - Monitor user feedback channels"
echo "  - Track key metrics daily"
echo "  - Have incident response plan ready"
echo ""
