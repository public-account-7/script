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
return(function(W,g,Gd,F,n,A,Ld,x,U,C,e,Jd,M,i,Hd,j,o,Yd,z,E,b,O,vd,td,R,Rd,Kd,L,J,q,od,a,_,G,Id,h,P,m)o=({});P=(60);repeat if P==0X003c then if not(not o[0X79F1])then P=(o[0X007_9f1_]);else P=(2961592538+((((q.N(m[0X5],(0X15)))-m[0X6]>m[0X4]and m[0X7]or m[0X3])-m[6]>m[0b1]and P or m[2])-m[0x3]));o[0X79f1]=(P);end;else if P==0B1101011 then break;end;end;until false;local B=(G.byte);P=(98);repeat if P>0X59 then if not o[10908]then P=(-4128552290+(q.N((q.u((q.J((q.v(P==m[0X1]and m[0B1001]or m[0x3],m[0X9])),(0B11_001)))))-m[0X2],(q.n('\>i8','\0\0\0\0\0\0\0\a')))));o[0X2a9c]=P;else P=o[0X2a9C];end;else if P<0X62 then break;end;end;until false;P=0x10;while true do if P>47 then break;else if P<0X02F then if not o[0x454__b__]then(o)[23086]=1497258062+((q.F(m[0X8]+P-m[0X2]+m[0X008__]-m[4]))-m[0X05]);o[0X5bb5]=-64066+(q.X((q.N(o[31217]-m[0b1],P))-m[0B100]-m[5]-m[0B10],P));P=-3963559359+(q.u(m[6]+P-P-m[0B101]+m[0B101]-m[0x2]));(o)[0X454B]=P;else P=o[0X454b];end;else if P<0X42 and P>0X10 then if not(not o[14736])then P=o[14736];else P=-2898600568+((q.z((q.N((q.z(m[0B100]-o[31217])),(0B1000))),m[0B11],m[0X4]))+o[23086]+o[31217]);o[0X3990]=(P);end;end;end;end;end;local _d,X,w;P=0X1e;repeat if P==0X0__01e then _d=td;if not(not o[0X3faF])then P=(o[0X3FAF]);else o[0x6942]=-3434593642+(q.z(o[0x5a2E]-m[0X9]-o[0X0_2A9c]+m[0B1000]+o[17739]-o[0X79F1],o[0x05a2E],m[0x4_]));P=0XB484+((q.X((q.I(o[0X79F1],P))+P-m[0X8],P))+P-m[1]);(o)[16303]=P;end;elseif P==0X65 then if not o[6073]then P=(q.I((q.i(((q.u(o[0X2a9C]+m[0X8]))<=m[0X7]and m[0B10]or m[1])-m[7])),(0X1A)));o[0X17b9]=P;else P=o[0X17b9];end;else if P==0B0__ then X=q.K;if not(not o[24004])then P=(o[24004]);else o[0x4e53]=-2160308382+(q.J(((q.i((q.z(o[17739],o[0X6942]))))-o[17739]==m[6]and o[0X69__4__2]or m[2])>=m[0b01]and m[0X4]or o[6073],(o[0X17B_9])));P=(0X5f+((q.z(o[0X3FAF]+m[0B1000]-o[0X5a2E]-m[0x1]))+o[23086]<o[6073]and o[0x6942]or o[6073]));(o)[0X5DC4]=P;end;continue;else if P==0X5F then w=({});if not o[0x7f96]then P=(0X32+((q.v((q.X((q.i(o[17739]+o[26946]<=o[0X6__9_42_]and m[
