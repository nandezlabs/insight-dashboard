# 7 Habits Workshop - Usage Guide

## Installation

```bash
cd templates/general-project
pip install -e .
```

## Overview

The 7 Habits Workshop is an interactive tool for tracking and practicing Stephen R. Covey's **7 Habits of Highly Effective People**. Track your daily actions, reflect on your progress, and build effectiveness through conscious practice.

### The 7 Habits

1. **Be Proactive** - Take responsibility for your life
2. **Begin with the End in Mind** - Define clear measures of success
3. **Put First Things First** - Prioritize what matters most
4. **Think Win-Win** - Seek mutual benefit in relationships
5. **Seek First to Understand, Then to Be Understood** - Listen with empathy
6. **Synergize** - Create collaborative solutions
7. **Sharpen the Saw** - Renew yourself physically, mentally, spiritually, socially

## Quick Start

### View Workshop Information

```bash
# Display all 7 habits with explanations
habits workshop
```

### Track Your First Habit Action

```bash
# Track by habit number (1-7)
habits track 1 --action "Declined blame, took ownership of the issue"

# Track with reflection
habits track 3 --action "Started day with most important task" \
  --reflection "Felt more productive and less stressed"

# Track by habit name (partial match works)
habits track "proactive" --action "Chose my response instead of reacting"
```

### Add Daily Reflections

```bash
# Simple reflection
habits reflect "Today I practiced active listening in my team meeting"

# Reflection with tags
habits reflect "Made time for exercise and reading today" \
  --tags self-care balance
```

### View Your Progress

```bash
# See overall progress
habits progress

# Progress for last 30 days
habits progress --days 30

# Progress for last week
habits progress --days 7
```

### List Recent Entries

```bash
# List all recent entries
habits list

# List entries for specific habit
habits list --habit 1

# Show more entries
habits list --limit 50
```

### View Reflections

```bash
# List recent reflections
habits reflections
```

### Export Reports

```bash
# Export as markdown
habits export --format markdown --output my_progress.md

# Export as JSON
habits export --format json --output my_progress.json
```

## Advanced Usage

### Custom Data Directory

```bash
# Use custom directory for data storage
habits --data-dir ~/Dropbox/7Habits track 1 --action "Custom location"

# All commands support custom directory
habits --data-dir ~/Dropbox/7Habits progress
```

### Habit Tracking Examples

#### Habit 1: Be Proactive

```bash
# Taking responsibility
habits track 1 --action "Took ownership of project delay instead of blaming others"

# Choosing response
habits track 1 --action "Paused before responding to difficult email"

# Circle of influence
habits track 1 --action "Focused on what I can control, let go of what I can't"
```

#### Habit 2: Begin with the End in Mind

```bash
# Personal mission
habits track 2 --action "Reviewed and updated my personal mission statement"

# Goal setting
habits track 2 --action "Set clear quarterly goals aligned with values"

# Visualization
habits track 2 --action "Visualized successful presentation outcome"
```

#### Habit 3: Put First Things First

```bash
# Prioritization
habits track 3 --action "Completed important but not urgent project planning"

# Time management
habits track 3 --action "Blocked calendar time for strategic thinking"

# Saying no
habits track 3 --action "Declined meeting that wasn't aligned with priorities"
```

#### Habit 4: Think Win-Win

```bash
# Collaboration
habits track 4 --action "Found solution that benefited both teams"

# Abundance mindset
habits track 4 --action "Celebrated colleague's success without comparison"

# Negotiation
habits track 4 --action "Negotiated contract terms that work for both parties"
```

#### Habit 5: Seek First to Understand

```bash
# Active listening
habits track 5 --action "Listened fully before offering advice"

# Empathy
habits track 5 --action "Asked questions to understand perspective before responding"

# Understanding
habits track 5 --action "Repeated back to ensure I understood correctly"
```

#### Habit 6: Synergize

```bash
# Collaboration
habits track 6 --action "Combined different ideas into better solution"

# Teamwork
habits track 6 --action "Leveraged team diversity to solve complex problem"

# Creative cooperation
habits track 6 --action "Brainstormed with team, arrived at innovative approach"
```

#### Habit 7: Sharpen the Saw

```bash
# Physical renewal
habits track 7 --action "30-minute morning workout"

# Mental renewal
habits track 7 --action "Read 50 pages of leadership book"

# Spiritual renewal
habits track 7 --action "20 minutes of meditation and reflection"

# Social/emotional renewal
habits track 7 --action "Quality time with family, no devices"
```

## File Storage

Data is stored as JSON files in:

- **Default**: `~/Documents/7HabitsWorkshop/`
- **Custom**: Use `--data-dir` flag
- **Files**:
  - `habit_entries.json` - All habit tracking entries
  - `reflections.json` - Daily reflections and journal entries

## Building Your Practice

### Daily Routine

```bash
#!/bin/bash
# morning_habits.sh - Add to your morning routine

echo "🌅 Morning Habits Check-in"
habits workshop

# Track morning habits
habits track 7 --action "Morning exercise and meditation"
habits track 2 --action "Reviewed daily goals and priorities"

# View progress
habits progress --days 7
```

### Weekly Review

```bash
#!/bin/bash
# weekly_review.sh - Run every Sunday

echo "📊 Weekly Habits Review"
habits progress --days 7
habits export --format markdown --output ~/Reviews/habits_$(date +%Y%m%d).md
echo "✓ Weekly report generated"
```

### Evening Reflection

```bash
#!/bin/bash
# evening_reflection.sh - End of day routine

echo "🌙 Evening Reflection"
echo "What habit did you practice today?"
read -p "Reflection: " reflection

habits reflect "$reflection" --tags daily evening
```

## Shell Aliases

Add to `.bashrc` or `.zshrc`:

```bash
# Quick habit tracking
alias h1='habits track 1 --action'
alias h2='habits track 2 --action'
alias h3='habits track 3 --action'
alias h4='habits track 4 --action'
alias h5='habits track 5 --action'
alias h6='habits track 6 --action'
alias h7='habits track 7 --action'

# Quick commands
alias hlist='habits list'
alias hprog='habits progress'
alias href='habits reflect'
alias hwork='habits workshop'
```

Usage:

```bash
h1 "Took responsibility for issue"
h3 "Started with most important task"
hprog --days 30
```

## Tips for Success

1. **Track daily** - Even small actions count, consistency matters
2. **Be specific** - "Exercised 30min" better than "practiced habit 7"
3. **Reflect often** - Use reflections to capture insights and patterns
4. **Review weekly** - Check progress every 7 days, celebrate wins
5. **Start small** - Focus on 1-2 habits at a time, build gradually
6. **Use reminders** - Set calendar alerts for tracking and reflection
7. **Export regularly** - Create monthly reports to see long-term growth

## Monthly Challenge Ideas

### Month 1: Foundation (Habits 1-3)

Focus on **Private Victory** - independence and self-mastery

- Week 1-2: Habit 1 (Be Proactive)
- Week 3: Habit 2 (Begin with the End in Mind)
- Week 4: Habit 3 (Put First Things First)

### Month 2: Relationships (Habits 4-6)

Focus on **Public Victory** - interdependence and teamwork

- Week 1-2: Habit 4 (Think Win-Win)
- Week 3: Habit 5 (Seek First to Understand)
- Week 4: Habit 6 (Synergize)

### Month 3: Renewal (Habit 7)

Focus on **Continuous Improvement** - balance and growth

- All weeks: Habit 7 (Sharpen the Saw)
- Track all four dimensions: physical, mental, spiritual, social

## Interpreting Your Progress

The progress report shows:

- **Total Entries**: Overall tracking consistency
- **Habit Counts**: Which habits you practice most
- **Visual Bars**: Quick visual of your focus areas

**Balanced progress** means all 7 habits have entries. **Gaps** might indicate:

- Habits 1-3 low: Work on independence and self-management
- Habits 4-6 low: Focus on relationships and collaboration
- Habit 7 low: Need more self-renewal and balance
