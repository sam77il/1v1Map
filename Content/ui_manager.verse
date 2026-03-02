using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }

ToMessage<localizes>(Content : string): message = "{Content}"

category := class<concrete>():
    @editable
    Label : string = ""

    @editable
    ID : string = ""

    @editable
    Items : []item = array{}

item := class<concrete>():
    @editable
    Label : string = ""
    ID : string = ""

    @editable
    Items : []finalitem = array{}

finalitem := class<concrete>():
    Label : string = ""
    ID : string = ""

ui_manager := class(creative_device):
    MainWidget : Widgets.W_GameConfig = Widgets.W_GameConfig{}

    @editable
    GameManager : game_manager = game_manager{}

    @editable
    SignalRemoteManager : signal_remote_manager_device = signal_remote_manager_device{}

    @editable
    Categories : []category = array{}

    ItemsPerPage : int = 6

    OnBegin<override>()<suspends>:void=
        SignalRemoteManager.PrimarySignalEvent.Subscribe(OnSignalRemotePrimary)

    OnSignalRemotePrimary(Agent : agent):void=
        ToggleUserInterface(Agent, true)

    ToggleUserInterface(Agent : agent, Toggle : logic):void=
        for (xPlayerMaybe : GameManager.xPlayers):
            if (xPlayerMaybe.Agent = Agent):
                xPlayer := xPlayerMaybe
                if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
                    if (not xPlayer.InitializedUI?):
                        spawn:
                            InitializeButtons(Agent)

                        set xPlayer.InitializedUI = true
                    if (Toggle?):
                        MainWidget.SetVisibility(widget_visibility.Visible)
                        PlayerUI.AddWidget(MainWidget, player_ui_slot{InputMode := ui_input_mode.All})
                    else:
                        MainWidget.SetVisibility(widget_visibility.Hidden)
                        PlayerUI.RemoveWidget(MainWidget)

    InitializeButtons(Agent : agent)<suspends>:void=
        Print("Initalizing Buttons")
        # Setting Text on Buttons
        set MainWidget.WeaponsText = ToMessage("Weapons")
        set MainWidget.SettingsText = ToMessage("Settings")
        set MainWidget.CloseText = ToMessage("Close")
        set MainWidget.PreviousText = ToMessage("<-")
        set MainWidget.NextText = ToMessage("->")

        race:
            loop:
                MainWidget.CloseEvent.Await()
                Print("Close")
                ToggleUserInterface(Agent, false)
            loop:
                MainWidget.PreviousEvent.Await()
                Print("Prev")
            loop:
                MainWidget.NextEvent.Await()
                Print("Next")
            loop:
                MainWidget.WeaponsEvent.Await()
                OnCategoryClick(Agent, "weapons")
            loop:
                MainWidget.SettingsEvent.Await()
                OnCategoryClick(Agent, "settings")
            loop:
                MainWidget.Item1Event.Await()
                OnItemClick(Agent, 1)
            loop:
                MainWidget.Item2Event.Await()
                OnItemClick(Agent, 2)
            loop:
                MainWidget.Item3Event.Await()
                OnItemClick(Agent, 3)
            loop:
                MainWidget.Item4Event.Await()
                OnItemClick(Agent, 4)
            loop:
                MainWidget.Item5Event.Await()
                OnItemClick(Agent, 5)
            loop:
                MainWidget.Item6Event.Await()
                OnItemClick(Agent, 6)

    OnCategoryClick(Agent : agent, cat : string):void=
        for (xPlayerMaybe : GameManager.xPlayers):
            if (xPlayerMaybe.Agent = Agent):
                xPlayer := xPlayerMaybe

                case (cat):
                    "weapons" => {
                        for (CategoryMaybe : Categories):
                            if (CategoryMaybe.ID = cat):
                                set xPlayer.SelectedCategory = CategoryMaybe
                                LoadCategoryContent(xPlayer)
                    }
                    "settings" => {
                        for (CategoryMaybe : Categories):
                            if (CategoryMaybe.ID = cat):
                                set xPlayer.SelectedCategory = CategoryMaybe
                                LoadCategoryContent(xPlayer)
                    }
                    _ => {}   
    
    LoadCategoryContent(xPlayer : xplayer):void=
        HideAllItems()
        for (I := 0..ItemsPerPage - 1, Index := I + (xPlayer.CurrentPage * ItemsPerPage)):
            if (CategoryItem := xPlayer.SelectedCategory.Items[Index]):     
                               
                LoadItem(xPlayer, Index, CategoryItem.Label, option{HTest})

    HTest(xPlayer : xplayer):void=
        {}
            
    LoadItem(xPlayer : xplayer, Index : int, Text : string, Event : ?type{_(:xplayer):void}):void=
        case (Index):
            0 => {
                set MainWidget.Item1Visibility = true
                set MainWidget.Item1Text = ToMessage(Text)
                set xPlayer.Item1Event = Event
            }
            1 => {
                set MainWidget.Item2Visibility = true
                set MainWidget.Item2Text = ToMessage(Text)
                set xPlayer.Item2Event = Event
            }
            2 => {
                set MainWidget.Item3Visibility = true
                set MainWidget.Item3Text = ToMessage(Text)
                set xPlayer.Item3Event = Event
            }
            3 => {
                set MainWidget.Item4Visibility = true
                set MainWidget.Item4Text = ToMessage(Text)
                set xPlayer.Item4Event = Event
            }
            4 => {
                set MainWidget.Item5Visibility = true
                set MainWidget.Item5Text = ToMessage(Text)
                set xPlayer.Item5Event = Event
            }
            5 => {
                set MainWidget.Item6Visibility = true
                set MainWidget.Item6Text = ToMessage(Text)
                set xPlayer.Item6Event = Event
            }
            _ => {}

    HideAllItems():void=
        set MainWidget.Item1Visibility = false
        set MainWidget.Item2Visibility = false
        set MainWidget.Item3Visibility = false
        set MainWidget.Item4Visibility = false
        set MainWidget.Item5Visibility = false
        set MainWidget.Item6Visibility = false

    OnItemClick(Agent : agent, Index : int):void=
        for (xPlayerMaybe : GameManager.xPlayers):
            if (xPlayerMaybe.Agent = Agent):
                xPlayer := xPlayerMaybe

                case (Index):
                    1 => {
                        if (fn := xPlayer.Item1Event?):
                            fn(xPlayer)
                    }
                    2 => {
                        if (fn := xPlayer.Item2Event?):
                            fn(xPlayer)
                    }
                    3 => {
                        if (fn := xPlayer.Item3Event?):
                            fn(xPlayer)
                    }
                    4 => {
                        if (fn := xPlayer.Item4Event?):
                            fn(xPlayer)
                    }
                    5 => {
                        if (fn := xPlayer.Item5Event?):
                            fn(xPlayer)
                    }
                    6 => {
                        if (fn := xPlayer.Item6Event?):
                            fn(xPlayer)
                    }
                    _ => {}