Config = {
    -- Notification Settings
    Notifications = {
        UseOKOKNotify = true,         -- Use okokNotify for notifications
        UseESXDefaultNotify = false,  -- Use ESX notification system
        UseQBCoreNotify = false,      -- Use QBCore notification system
        NotificationDuration = 5000,  -- Duration of the notification in milliseconds
        Message = "You are hurt, go to the hospital to get treated.", -- Message to be displayed
    },

    -- Health Management
    Health = {
        HurtThreshold = 160,          -- Health threshold below which the player is considered hurt
        HealthReduction = 3,          -- Amount of health reduced per interval when hurt
        ReductionInterval = 60000,    -- Time interval (in milliseconds) for health reduction
        RecoveryThreshold = 161,      -- Health level above which the player is considered recovered
    },

    -- Visual Effects
    VisualEffects = {
        EnableScreenEffect = true,    -- Enable screen effect when hurt
        ScreenEffect = 'Rampage',     -- Screen effect to use
        EnableCameraShake = true,     -- Enable camera shake when hurt
        CameraShakeIntensity = 0.12,  -- Intensity of the camera shake
    }
}






