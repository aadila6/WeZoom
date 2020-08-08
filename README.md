# WeZoom

### Goal
Create and start/Join a meeting on demand using MobileRTC framework

### Approach
For simplicity I have put all the SDK Auth and Zoom User Auth in AppDelegate where this can change to other view controllers once the USER type in their information.
1. Please look at the AppDelegate to change these constance.
2. On the view controller, The start function will trigger to create a meeting with a meeting topic, you can edit it and change. 
3. Start meeting time, for now I have just put it on the call back function where once the meeting is successfully created, it will start it immediate, but for future uses, you can move the startMeeting function in its disired locations. 

### Final Reminder
Please be aware the sequence of how it will works and race condition may apply
1. SDK Authenticated
2. Zoom User Logged In
3. Create meeting with custom topic and title
4. Start the Created meeting
