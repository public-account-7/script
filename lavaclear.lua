if game.PlaceId == 15552588346 then
    local Players = game:GetService("Players")
    local bindable = Instance.new("BindableFunction")

    function bindable.OnInvoke(buttonPressed)
        if buttonPressed == "Yes" then
            if workspace:FindFirstChild("Lava") then
                workspace:FindFirstChild("Lava"):Destroy()
                print("lava cooked lmao")
            end

            workspace.DescendantAdded:Connect(function(child)
                if child.Name == "Lava" then
                    child:Destroy()
                    print("lava cooked lmao")
                end
            end)
        end
    end

    game.StarterGui:SetCore("SendNotification", {
        Title = "Automatic Delete Lava?",
        Text = "skid hub",
        Icon = "",
        Duration = math.huge,
        Callback = bindable,
        Button1 = "Yes",
        Button2 = "No"
    })
end
