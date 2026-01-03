# Testing Checklist - Insight Apps

**Date:** December 26, 2025  
**Apps:** Store Manager (macOS) + Store (iOS Simulator)  
**Backend:** Running on localhost:8000

---

## 🎯 Pre-Testing Setup

### Backend Verification

- [ ] Backend running on port 8000
- [ ] Test API endpoint: `curl http://localhost:8000/api/v1/goals/`
- [ ] Database initialized (`insight.db` exists)

### Test Data Required

- [ ] At least 2-3 Goals created (SALES_WEEK, GEM_PERIOD, LABOR_PERCENTAGE)
- [ ] KPI data for the past 2-3 weeks/periods
- [ ] At least 1 form template created
- [ ] Team members configured

---

## 📊 Store Manager App - Testing

### 1. Initial Launch

- [ ] App launches without errors
- [ ] Main navigation visible
- [ ] No console errors in Flutter DevTools

### 2. Analytics Dashboard - NEW FEATURE ⭐

#### Navigation

- [ ] Navigate to Analytics screen
- [ ] See 2 tabs: "KPI Trends" (new) and "Form Completion" (existing)
- [ ] Both tabs accessible

#### KPI Trends Tab - Core Functionality

- [ ] Tab loads without errors
- [ ] Empty state shows when no data exists
- [ ] Loading indicators display during data fetch

#### Period Filtering

- [ ] **Week** filter chip selectable
- [ ] **Period** filter chip selectable
- [ ] **Quarter** filter chip selectable
- [ ] **Year** filter chip selectable
- [ ] **Custom** filter opens date picker
- [ ] Custom date range: Start date picker works
- [ ] Custom date range: End date picker works
- [ ] Custom date range: Date validation (start < end)
- [ ] Filter changes trigger data reload

#### Trend Line Charts (With Test Data)

- [ ] **Sales Trend Chart** renders

  - [ ] Actual line displays in primary color
  - [ ] Target line displays as dashed
  - [ ] Shaded area under actual line visible
  - [ ] Chart legend shows both lines
  - [ ] Y-axis scales appropriately
  - [ ] X-axis shows date labels

- [ ] **GEM Trend Chart** renders

  - [ ] Data points match expected values
  - [ ] Tooltips show on hover/tap
  - [ ] Chart responsive to window resize

- [ ] **Labor % Trend Chart** renders
  - [ ] Percentage values formatted correctly
  - [ ] Goal line matches target percentage
  - [ ] Variance calculations accurate

#### Interactive Features

- [ ] Hover/tap on data points shows tooltip
- [ ] Tooltip displays: Date, Actual value, Target value, Variance
- [ ] Tooltip formatting: Currency ($), Percentages (%)
- [ ] Charts pan/zoom if enabled

#### Period Comparison Charts

- [ ] **Sales Comparison** bar chart renders
- [ ] **GEM Comparison** bar chart renders
- [ ] **Labor % Comparison** bar chart renders
- [ ] Bars grouped by period (Actual + Target side-by-side)
- [ ] Color coding: Green (on/above target), Amber (below target)
- [ ] Period labels on X-axis readable

#### Summary Metrics Cards

- [ ] Total/Average metrics display above charts
- [ ] Values formatted correctly
- [ ] Metrics update when filter changes
- [ ] Variance indicators (↑↓) show correctly

#### Forecasting (If Data Available)

- [ ] Forecast line appears on trend charts (dotted)
- [ ] Forecast extends beyond current date
- [ ] Forecast calculations reasonable (linear regression)

#### Error Handling

- [ ] No backend: Shows error message
- [ ] No data: Shows "No data available" state
- [ ] Invalid date range: Shows validation error
- [ ] Network timeout: Shows retry option

### 3. Form Completion Analytics (Existing)

- [ ] Form Completion tab loads
- [ ] Statistics display correctly
- [ ] Charts render (if implemented)

### 4. Export Functionality

- [ ] Export menu accessible (3-dot icon)
- [ ] **Export to CSV** option visible
- [ ] CSV export downloads file
- [ ] CSV contains correct data columns
- [ ] **Export to PDF** option visible
- [ ] PDF export generates document
- [ ] PDF layout formatted properly
- [ ] **Print** option visible
- [ ] Print dialog opens

### 5. General App Functionality

- [ ] Navigation between screens works
- [ ] Back button functionality
- [ ] App state persists on navigation
- [ ] No memory leaks (check DevTools)
- [ ] Responsive layout on window resize

### 6. Performance

- [ ] Charts render in < 2 seconds
- [ ] Smooth scrolling
- [ ] No UI freezing during data load
- [ ] Hot reload works for code changes

---

## 📱 Store App - Testing

### 1. Initial Launch

- [ ] App launches on iOS Simulator
- [ ] Splash screen displays
- [ ] Login/Home screen appears
- [ ] No console errors

### 2. Offline Mode - RECENTLY COMPLETED ✅

#### Connectivity Detection

- [ ] App detects online status correctly
- [ ] Connectivity indicator visible in UI
- [ ] Status changes when network toggles

#### Offline Form Completion

- [ ] Navigate to form completion screen
- [ ] Disable network (Airplane mode / Network Link Conditioner)
- [ ] Forms still accessible offline
- [ ] Fill out a form offline
- [ ] Form data saved locally
- [ ] "Offline" indicator visible

#### Local Storage

- [ ] Completed forms stored in local DB
- [ ] Can view completed forms offline
- [ ] Form list shows pending sync indicator
- [ ] Data persists after app restart

#### Sync Functionality

- [ ] Re-enable network connection
- [ ] "Sync" button visible when online
- [ ] Tap sync button
- [ ] Offline submissions upload to backend
- [ ] Success indicator shows after sync
- [ ] Local sync queue clears

#### Conflict Resolution - RECENTLY COMPLETED ✅

- [ ] Create conflicting data scenario:
  - [ ] Edit same form on two devices
  - [ ] Make different changes
  - [ ] Sync first device
  - [ ] Attempt sync second device
- [ ] Conflict resolution screen appears
- [ ] Shows both versions side-by-side
- [ ] **Keep Local** button works
- [ ] **Keep Remote** button works
- [ ] **Manual Merge** option available (if implemented)
- [ ] Resolution saves correctly
- [ ] No data loss after resolution

### 3. Form Completion Features

#### Form Access

- [ ] Form list loads online
- [ ] Forms cached for offline use
- [ ] Search/filter forms works
- [ ] Form tags visible (daily, weekly, period)

#### Completing Forms

- [ ] Open a form
- [ ] All field types render:
  - [ ] Short text input
  - [ ] Long text (textarea)
  - [ ] Number input (with validation)
  - [ ] Date picker
  - [ ] Time picker
  - [ ] Dropdown selection
  - [ ] Radio buttons
  - [ ] Checkboxes
  - [ ] Email (with validation)
  - [ ] Phone (with formatting)
  - [ ] File upload
- [ ] Field validation works
- [ ] Required fields enforced
- [ ] **"Completed by" fields accept employee names**
- [ ] **Multiple sections can have different "Completed by" entries**

#### Auto-Save

- [ ] Enter data in form fields
- [ ] Wait 500ms (debounce time)
- [ ] Check "Draft saved" indicator appears
- [ ] Close and reopen form
- [ ] Draft data restored correctly

#### Form Submission

- [ ] Complete all required fields
- [ ] Tap "Submit" button
- [ ] **Online:** Submits immediately to backend
- [ ] **Offline:** Queues for sync
- [ ] Success message displays
- [ ] Return to form list

### 4. Geofencing (If Implemented)

- [ ] Location permission requested
- [ ] Location services enabled
- [ ] Geofence radius configured (default 100m)
- [ ] Form access restricted outside geofence
- [ ] Warning message shows when out of range
- [ ] Form accessible when inside geofence

### 5. Operations Dashboard (If Implemented)

- [ ] Dashboard loads
- [ ] Weather widget displays current conditions
- [ ] KPI summary cards visible
- [ ] Quick actions accessible

### 6. Error Handling

- [ ] Network errors show user-friendly messages
- [ ] Form validation errors clear
- [ ] Retry mechanisms work
- [ ] App doesn't crash on errors

### 7. Performance

- [ ] App launches in < 3 seconds
- [ ] Forms load quickly (< 1 second)
- [ ] Smooth scrolling through form lists
- [ ] No lag when typing in fields
- [ ] Battery usage reasonable

---

## 🔗 Integration Testing

### Store Manager → Backend

- [ ] Create a new goal in Store Manager
- [ ] Verify goal appears in analytics charts
- [ ] Update goal value
- [ ] Chart updates accordingly
- [ ] Delete goal
- [ ] Chart removes data point

### Store → Backend → Store Manager

- [ ] Complete form on Store app (online)
- [ ] **Enter employee name in "Completed by" field**
- [ ] Submission appears in Store Manager analytics
- [ ] **Employee name visible in submission details**
- [ ] Complete form offline with employee name
- [ ] Sync submission
- [ ] Verify appears in Store Manager with correct attribution

### Business Calendar Integration

- [ ] Create goal for specific Period
- [ ] Verify correct period matching in charts
- [ ] Filter by Quarter
- [ ] All periods in quarter included
- [ ] Year filter shows all 13 periods

---

## 🐛 Known Issues / Edge Cases

### Items to Watch For:

- [ ] Chart rendering with insufficient data (< 3 points)
- [ ] Date range spanning year boundaries
- [ ] Large datasets (> 100 data points) performance
- [ ] Multiple rapid filter changes
- [ ] Export with special characters in data
- [ ] Offline→Online transition edge cases
- [ ] Conflict resolution with deleted items
- [ ] Form submission timeout handling
- [ ] Geofence accuracy in simulator (use mock location)

---

## ✅ Success Criteria

### Store Manager

- ✅ All 3 trend charts render with real data
- ✅ Period filtering changes data correctly
- ✅ Exports work without errors
- ✅ No console errors during normal usage
- ✅ Smooth performance (60fps)

### Store

- ✅ Offline mode works reliably
- ✅ Sync completes without data loss
- ✅ Conflict resolution UI functional
- ✅ Forms save and submit correctly
- ✅ All tests pass (28/28 ✅)

---

## 📝 Testing Notes

### Record Issues Here:

```
Issue #1: [Description]
Steps to reproduce:
1.
2.
3.
Expected:
Actual:
Priority: High/Medium/Low
```

---

## 🚀 Next Steps After Testing

1. **If Issues Found:**

   - Document in issues section above
   - Create GitHub issues
   - Prioritize fixes

2. **If All Green:**

   - Run automated tests: `melos test`
   - Build production releases
   - Consider Option E: NAS Deployment

3. **Analytics Enhancements (Optional):**

   - Add more chart types (pie, scatter)
   - Implement drill-down views
   - Add comparison to previous periods
   - Export customization options
   - Real-time updates via WebSocket

4. **Store App Enhancements:**
   - Implement photo capture for file fields
   - Add operations dashboard with weather
   - Build submission review/edit UI
   - Add push notifications for new forms

---

**Testing Start Time:** ****\_\_\_\_****  
**Testing End Time:** ****\_\_\_\_****  
**Tester:** ****\_\_\_\_****  
**Overall Status:** ⬜ Pass | ⬜ Pass with Issues | ⬜ Fail
