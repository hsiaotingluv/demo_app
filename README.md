# Calendar App

A new Flutter Calendar App that allows users to add events and view their schedule on calendar.

<img width="380" alt="Screenshot 2022-05-18 at 12 34 13 PM" src="https://user-images.githubusercontent.com/68311371/168958083-1307a277-aeea-4386-a93e-3c909879195a.png">
<img width="384" alt="Screenshot 2022-05-18 at 12 33 41 PM" src="https://user-images.githubusercontent.com/68311371/168958104-a4ae2e30-ed8f-472b-b50d-458e2ef565fc.png">


# Requirements

## Home Page:
- Not much needed on first page
- Able to open side menu from left (swiping and/or hamburger menu button to open it up)
- Button in side menu to open Calendar Page (using navigator push)

## Calendar overview page:
- https://pub.dev/packages/table_calendar you may use others
- Able to see calendar overview in this page
- Can create new event via plus button at bottom right

## Event creation page:
- For the start date field it should be set to whatever date was selected in previous page (still changable), meaning you need to pass that info to this page during navigator push
- Standard stuff like event title, whole day vs start/end time, multiple days selection should be in. Refer to the calendar package to see what's already available.
- After adding event, it should be visible on calendar immediately

## Others
- You can use sharedpreferences or Hive (https://pub.dev/packages/hive) to save app data
- Add any bells and whistles as you see fit
