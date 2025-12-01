# Checklist Feature

## Overview
Added a checklist feature to the notes app with a tab bar view that allows users to create and manage checklists alongside their notes.

## Files Created

### 1. `lib/services/cloud/cloud_checklist.dart`
- CloudChecklist model with fields: documentId, ownerUserId, title, items, createdDate, favourite
- ChecklistItem class with fields: id, text, isChecked
- Includes serialization methods (toMap/fromMap)

### 2. `lib/view/checklists/checklist_list_view.dart`
- Displays checklists in a grid view (matching notes layout)
- Shows up to 3 checklist items preview with checkboxes
- Displays progress bar for completed items
- Shows completion count (e.g., "3/5")
- Shows favorite star icon
- Uses same card styling and colors as notes
- Supports tap and long press callbacks

## Files Modified

### 1. `lib/services/cloud/cloud_storage_constants.dart`
- Added checklist field names:
  - `checklistTitleFieldName`
  - `checklistItemsFieldName`

### 2. `lib/services/cloud/firebase_cloud_storage.dart`
- Added `checklists` collection reference
- Implemented CRUD operations:
  - `createNewChecklist()` - Creates a new empty checklist
  - `allChecklists()` - Stream of all user checklists (sorted by favorite, then date)
  - `allFavouriteChecklists()` - Stream of favorite checklists only
  - `updateChecklist()` - Updates checklist title, items, and favorite status
  - `deleteChecklist()` - Deletes a checklist

### 3. `lib/view/checklists/checklists_screen.dart`
- New dedicated screen for checklists
- Simple AppBar with back button and add action
- Grid layout displaying all checklists
- `_showChecklistDialog()` - Dialog for creating/editing checklists
  - Title input field
  - Favorite toggle
  - List of checklist items with checkboxes
  - Add/delete item functionality
- `showChecklistBottomSheet()` - Bottom sheet for checklist actions (delete)

### 4. `lib/view/notes/notes_screen.dart`
- Removed TabController and tab bar
- Added floating action button to navigate to checklists screen
- Simplified to focus only on notes functionality

### 5. `lib/view/route/routes.dart`
- Added `checklists` route constant

### 6. `lib/view/route/app_router.dart`
- Added route mapping for ChecklistsScreen

## Features

### Checklist Management
- Create new checklists with custom titles
- Add/remove checklist items
- Check/uncheck items
- Mark checklists as favorites
- Delete checklists
- Filter by favorites

### UI/UX
- Separate screen for checklists (accessed via floating action button from notes screen)
- Simple AppBar with back button and add action
- Progress indicator shows completion status
- Grid layout matching notes design
- Consistent card styling with notes feature

## Firebase Structure

### Checklists Collection
```
checklists/
  {documentId}/
    user_id: string
    title: string
    items: array[
      {
        id: string
        text: string
        isChecked: boolean
      }
    ]
    created_date: string (ISO 8601)
    favourite: boolean
```

## Usage

1. Switch to "Checklists" tab
2. Tap "+" button to create a new checklist
3. Enter title and add items
4. Check/uncheck items as you complete them
5. Long press to delete a checklist
6. Use filter menu to show all or only favorites
