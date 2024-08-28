
local hurt = false
local ESX, QBCore = nil, nil

-- Initialize ESX or QBCore based on the active framework
Citizen.CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

-- Reduce health over time if the player is hurt
Citizen.CreateThread(function()
    while true do
        Wait(Config.Health.ReductionInterval) -- Wait based on the configured interval
        if hurt and GetEntityHealth(GetPlayerPed(-1)) > Config.Health.HealthReduction then
            SetEntityHealth(GetPlayerPed(-1), GetEntityHealth(GetPlayerPed(-1)) - Config.Health.HealthReduction)
        end
    end
end)

-- Monitor player's health and trigger notifications and effects
Citizen.CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        local playerHealth = GetEntityHealth(GetPlayerPed(-1))
        if playerHealth <= Config.Health.HurtThreshold and playerHealth > 0 then
            -- Trigger notifications based on configuration
            if Config.Notifications.UseOKOKNotify then
                exports['okokNotify']:Alert("", Config.Notifications.Message, Config.Notifications.NotificationDuration, 'error')
            elseif Config.Notifications.UseESXDefaultNotify and ESX then
                ESX.ShowNotification(Config.Notifications.Message)
            elseif Config.Notifications.UseQBCoreNotify and QBCore then
                QBCore.Functions.Notify(Config.Notifications.Message, "error")
            end

            -- Apply visual effects and hurt state
            if Config.VisualEffects.EnableScreenEffect then
                StartScreenEffect(Config.VisualEffects.ScreenEffect)
            end
            if Config.VisualEffects.EnableCameraShake then
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', Config.VisualEffects.CameraShakeIntensity)
            end
            setHurt()
            Wait(Config.Health.ReductionInterval) -- wait the same interval as health reduction
        elseif hurt and playerHealth > Config.Health.RecoveryThreshold then
            setNotHurt()
        end
    end
end)

-- Stop effects when health is above the threshold
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerHealth = GetEntityHealth(GetPlayerPed(-1))
        if playerHealth > Config.Health.RecoveryThreshold then
            if Config.VisualEffects.EnableScreenEffect then
                StopScreenEffect(Config.VisualEffects.ScreenEffect)
            end
            setNotHurt()
        end
    end
end)

-- Handle player death event
AddEventHandler('playerDied', function()
    setNotHurt() 
end)

-- Set player to "hurt" state
function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
end

-- Reset player from "hurt" state
function setNotHurt()
    hurt = false
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
end
