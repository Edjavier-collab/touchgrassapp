# Sprint 1 Board - TouchGrass MVP Core

**Sprint Goal**: Deliver core functionality for users to create WOOPs and track 24-hour periods
**Sprint Duration**: 2 weeks
**Total Points**: 24

## 📊 Sprint Metrics
- **Velocity Target**: 24 points
- **Team Capacity**: 100%
- **Sprint Start**: TBD
- **Sprint End**: TBD

## 🏃 Sprint Backlog

### 📝 TODO (24 points)

#### US-1: Device Registration (3 points)
**As a** new user  
**I want to** start using the app immediately without creating an account  
**So that** I can begin tracking my cravings with minimal friction  

**Acceptance Criteria:**
- [ ] App generates unique device ID on first launch
- [ ] Device ID is stored in localStorage
- [ ] Device ID is registered in Supabase
- [ ] User data persists across browser sessions
- [ ] No personal information is required

**Technical Tasks:**
- [ ] Implement device ID generation utility
- [ ] Create Supabase table for devices
- [ ] Add device registration API endpoint
- [ ] Implement localStorage persistence layer
- [ ] Add error handling for failed registrations

---

#### US-3: Create WOOP Entry (5 points)
**As a** user  
**I want to** create a WOOP (Wish, Outcome, Obstacle, Plan) entry  
**So that** I can mentally prepare before starting my timer  

**Acceptance Criteria:**
- [ ] Form with 4 text fields (max 280 chars each)
- [ ] All fields are required
- [ ] Autosave every 5 seconds
- [ ] Visual feedback on save status
- [ ] Mobile-friendly input fields

**Technical Tasks:**
- [ ] Create WOOP form component
- [ ] Implement character counter
- [ ] Add autosave with debouncing
- [ ] Create save status indicator
- [ ] Add form validation
- [ ] Style for mobile responsiveness

---

#### US-4: Edit Draft WOOP (3 points)
**As a** user  
**I want to** edit my WOOP entry before starting the timer  
**So that** I can refine my thoughts  

**Acceptance Criteria:**
- [ ] Edit button available on draft WOOP
- [ ] Changes autosave
- [ ] Cannot edit after timer starts
- [ ] Clear indication of draft vs active state

**Technical Tasks:**
- [ ] Add edit mode to WOOP form
- [ ] Implement draft state management
- [ ] Add UI state indicators
- [ ] Lock editing when timer active

---

#### US-5: Start Craving Timer (8 points)
**As a** user  
**I want to** start a 24-hour timer after completing my WOOP  
**So that** I can track how long I resist my craving  

**Acceptance Criteria:**
- [ ] Start button begins timer from 0:00:00
- [ ] Timer counts up to 24:00:00
- [ ] Display shows hours:minutes:seconds
- [ ] Timer persists across page refreshes
- [ ] Only one active timer allowed
- [ ] Timer state saved to localStorage

**Technical Tasks:**
- [ ] Create timer component
- [ ] Implement timer logic with intervals
- [ ] Add timer persistence to localStorage
- [ ] Create timer display formatting
- [ ] Add start button with validation
- [ ] Implement single timer constraint
- [ ] Handle page visibility API

---

#### US-6: Stop Timer (Success/Slip) (5 points)
**As a** user  
**I want to** stop my timer when I reach 24 hours or if I slip  
**So that** I can log my progress accurately  

**Acceptance Criteria:**
- [ ] Auto-stop at exactly 24 hours
- [ ] "I slipped" button stops timer early
- [ ] Duration logged in seconds
- [ ] Linked to WOOP entry ID
- [ ] Timestamp recorded
- [ ] Appropriate celebration/encouragement shown

**Technical Tasks:**
- [ ] Add timer auto-stop logic
- [ ] Create slip button component
- [ ] Implement timer result storage
- [ ] Add success/slip UI feedback
- [ ] Create celebration animation
- [ ] Store results in Supabase

---

### 🚧 IN PROGRESS (0 points)

*No items currently in progress*

### ✅ DONE (0 points)

*No items completed yet*

---

## 🚫 Blocked Items

*No blocked items*

---

## 📋 Definition of Done Checklist

For each user story:
- [ ] Code complete and reviewed
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Accessibility tested (keyboard navigation, screen reader)
- [ ] Mobile responsive verified
- [ ] Cross-browser tested (Chrome, Firefox, Safari)
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] Product owner approval

---

## 🎯 Sprint Dependencies

### Required Before Sprint Start:
1. **Supabase Setup**
   - Database provisioned
   - Authentication configured
   - Tables created for devices, woops, timers
   
2. **Development Environment**
   - Node.js/npm installed
   - Next.js project initialized
   - ESLint/Prettier configured
   - Git repository set up

3. **Design Assets**
   - WOOP form mockups
   - Timer UI design
   - Mobile layouts
   - Color scheme/branding

---

## 📊 Daily Standup Template

**Format**: 15-minute timeboxed meeting

**Questions**:
1. What did you complete yesterday?
2. What will you work on today?
3. Are there any blockers?

**Parking Lot**: Technical discussions > 2 minutes go here

---

## 🔄 Sprint Ceremonies

### Sprint Planning
- Review sprint goal
- Confirm story readiness
- Task breakdown session
- Capacity planning

### Daily Standup
- Every day at [TIME]
- 15 minutes max
- Focus on progress & blockers

### Sprint Review
- Demo completed stories
- Gather stakeholder feedback
- Update product backlog

### Sprint Retrospective
- What went well?
- What could improve?
- Action items for next sprint