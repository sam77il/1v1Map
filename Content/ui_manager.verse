using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }

ToMessage<localizes>(Content : string): message = "{Content}"

setting_type := enum:
    Health
    Sprint
    MapFloor

category := class<concrete>():
    @editable
    Label : string = ""

    @editable
    ID : string = ""

    @editable
    Items : []category_item = array{}

item := class<concrete>():
    @editable
    Label : string = ""

    @editable
    ID : string = ""

category_item := class<concrete>(item):
    @editable
    Items : []final_item = array{}

final_item := class<concrete>(item):

weapon_final_item := class<concrete>(final_item):
    @editable
    Index : int = 0

setting_final_item := class<concrete>(final_item):
    @editable
    Type : setting_type = setting_type.Health
    
    @editable
    Amount : int = 100

    @editable
    Sequence : cinematic_sequence_device = cinematic_sequence_device{}

    @editable
    UnlimitedSprint : logic = false

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
        Print("{GameManager.xPlayers.Length}")
        for (xPlayerMaybe : GameManager.xPlayers):
            if (xPlayerMaybe.Agent = Agent):
                Print("Found xPlayer")
                xPlayer := xPlayerMaybe
                if (Player := player[Agent], PlayerUI := GetPlayerUI[Player]):
                    if (not xPlayer.InitializedUI?):
                        spawn:
                            InitializeButtons(xPlayer)

                        set xPlayer.InitializedUI = true
                    if (Toggle?):
                        Print("Toggling")
                        MainWidget.SetVisibility(widget_visibility.Visible)
                        PlayerUI.AddWidget(MainWidget, player_ui_slot{InputMode := ui_input_mode.All})
                    else:
                        MainWidget.SetVisibility(widget_visibility.Hidden)
                        PlayerUI.RemoveWidget(MainWidget)

    InitializeButtons(xPlayer : xplayer)<suspends>:void=
        Print("Initalizing Buttons")
        set MainWidget.WeaponsText = ToMessage("Weapons")
        set MainWidget.SettingsText = ToMessage("Settings")
        set MainWidget.CloseText = ToMessage("Close")
        set MainWidget.PreviousText = ToMessage("<-")
        set MainWidget.NextText = ToMessage("->")

        race:
            loop:
                MainWidget.CloseEvent.Await()
                ToggleUserInterface(xPlayer.Agent, false)
            loop:
                MainWidget.PreviousEvent.Await()
                HandlePageChanger(xPlayer, "previous")
            loop:
                MainWidget.NextEvent.Await()
                HandlePageChanger(xPlayer, "next")
            loop:
                MainWidget.WeaponsEvent.Await()
                OnCategoryClick(xPlayer, "weapons")
            loop:
                MainWidget.SettingsEvent.Await()
                OnCategoryClick(xPlayer, "settings")
            loop:
                MainWidget.Item1Event.Await()
                OnItemClick(xPlayer, 1)
            loop:
                MainWidget.Item2Event.Await()
                OnItemClick(xPlayer, 2)
            loop:
                MainWidget.Item3Event.Await()
                OnItemClick(xPlayer, 3)
            loop:
                MainWidget.Item4Event.Await()
                OnItemClick(xPlayer, 4)
            loop:
                MainWidget.Item5Event.Await()
                OnItemClick(xPlayer, 5)
            loop:
                MainWidget.Item6Event.Await()
                OnItemClick(xPlayer, 6)

    HandlePageChanger(xPlayer : xplayer, Type : string):void=
        if (Type = "next"):
            if (ItemMaybe := category_item[xPlayer.SelectedItems[0]]):
                set xPlayer.CurrentPage += 1
                LoadCategoryContent(xPlayer, false)
            else if (ItemMaybe := final_item[xPlayer.SelectedItems[0]]):
                set xPlayer.CurrentPage -= 1
                # LoadCategoryItemContent(xPlayer, false, false)                

    
    OnCategoryClick(xPlayer : xplayer, cat : string):void=
        case (cat):
            "weapons" => {
                for (CategoryMaybe : Categories):
                    if (CategoryMaybe.ID = cat):
                        set xPlayer.SelectedCategory = CategoryMaybe
                        LoadCategoryContent(xPlayer, true)
            }
            "settings" => {
                for (CategoryMaybe : Categories):
                    if (CategoryMaybe.ID = cat):
                        set xPlayer.SelectedCategory = CategoryMaybe
                        LoadCategoryContent(xPlayer, true)
            }
            _ => {}   
    
    LoadCategoryContent(xPlayer : xplayer, ResetPages : logic):void=
        HideAllItems()
        if (ResetPages?):
            set xPlayer.CurrentPage = 0

        set xPlayer.SelectedItems = xPlayer.SelectedCategory.Items
        for (I := 0..ItemsPerPage - 1, Index := I + (xPlayer.CurrentPage * ItemsPerPage)):
            if (CategoryItem := xPlayer.SelectedCategory.Items[Index]):
                ItemData := item_data{Event := ClickCategoryItem, Data := CategoryItem}
                LoadItem(xPlayer, ItemData, I, CategoryItem.Label)

    ClickCategoryItem(xPlayer : xplayer, Index : int):void=
        Print("Clicked CategoryItem {Index}")
        HideAllItems()
        set xPlayer.CurrentPage = 0

        case (Index):
            1 => {
                LoadCategoryItemContent(xPlayer, xPlayer.Item1Data, true)
            }
            2 => {
                LoadCategoryItemContent(xPlayer, xPlayer.Item2Data, true)
            }
            3 => {
                LoadCategoryItemContent(xPlayer, xPlayer.Item3Data, true)
            }
            4 => {
                LoadCategoryItemContent(xPlayer, xPlayer.Item4Data, true)
            }
            5 => {
                LoadCategoryItemContent(xPlayer, xPlayer.Item5Data, true)
            }
            6 => {
                LoadCategoryItemContent(xPlayer, xPlayer.Item6Data, true)
            }
            _ => {}

    ClickFinalItem(xPlayer : xplayer, Index : int):void=
        Print("Clicked FinalItem {Index}")

        case (Index):
            1 => {
                LoadFinalItemContent(xPlayer, xPlayer.Item1Data)
            }
            2 => {
                LoadFinalItemContent(xPlayer, xPlayer.Item2Data)
            }
            3 => {
                LoadFinalItemContent(xPlayer, xPlayer.Item3Data)
            }
            4 => {
                LoadFinalItemContent(xPlayer, xPlayer.Item4Data)
            }
            5 => {
                LoadFinalItemContent(xPlayer, xPlayer.Item5Data)
            }
            6 => {
                LoadFinalItemContent(xPlayer, xPlayer.Item6Data)
            }
            _ => {}

    LoadFinalItemContent(xPlayer : xplayer, ItemData : item_data):void=
        if (xPlayer.SelectedCategory.ID = "weapons"):
            if (Item := weapon_final_item[ItemData.Data]):
                Print("{Item.Index}")
        else if (xPlayer.SelectedCategory.ID = "settings"):
            if (Item := setting_final_item[ItemData.Data]):
                if (Item.Type = setting_type.Health):

    
    LoadCategoryItemContent(xPlayer : xplayer, ItemData : item_data, ResetPages : logic):void=
        if (Item := category_item[ItemData.Data]):
            set xPlayer.SelectedItems = Item.Items
            if (ResetPages?):
                set xPlayer.CurrentPage = 0

            for (I := 0..ItemsPerPage - 1, Index := I + (xPlayer.CurrentPage * ItemsPerPage)):
                if (NewItem := Item.Items[Index]):
                    ID := item_data{Event := ClickFinalItem, Data := NewItem}
                    LoadItem(xPlayer, ID, I, NewItem.Label)

    LoadItem(xPlayer : xplayer, ItemData : item_data, Index : int, Text : string):void=
        case (Index):
            0 => {
                set MainWidget.Item1Visibility = true
                set MainWidget.Item1Text = ToMessage(Text)
                set xPlayer.Item1Data = ItemData
            }
            1 => {
                set MainWidget.Item2Visibility = true
                set MainWidget.Item2Text = ToMessage(Text)
                set xPlayer.Item2Data = ItemData
            }
            2 => {
                set MainWidget.Item3Visibility = true
                set MainWidget.Item3Text = ToMessage(Text)
                set xPlayer.Item3Data = ItemData
            }
            3 => {
                set MainWidget.Item4Visibility = true
                set MainWidget.Item4Text = ToMessage(Text)
                set xPlayer.Item4Data = ItemData
            }
            4 => {
                set MainWidget.Item5Visibility = true
                set MainWidget.Item5Text = ToMessage(Text)
                set xPlayer.Item5Data = ItemData
            }
            5 => {
                set MainWidget.Item6Visibility = true
                set MainWidget.Item6Text = ToMessage(Text)
                set xPlayer.Item6Data = ItemData
            }
            _ => {}

    OnItemClick(xPlayer : xplayer, Index : int):void=
        case (Index):
            1 => {
                xPlayer.Item1Data.Event(xPlayer, 1)
            }
            2 => {
                xPlayer.Item2Data.Event(xPlayer, 2)
            }
            3 => {
                xPlayer.Item3Data.Event(xPlayer, 3)
            }
            4 => {
                xPlayer.Item4Data.Event(xPlayer, 4)
            }
            5 => {
                xPlayer.Item5Data.Event(xPlayer, 5)
            }
            6 => {
                xPlayer.Item6Data.Event(xPlayer, 6)
            }
            _ => {}
            
    HideAllItems():void=
        set MainWidget.Item1Visibility = false
        set MainWidget.Item2Visibility = false
        set MainWidget.Item3Visibility = false
        set MainWidget.Item4Visibility = false
        set MainWidget.Item5Visibility = false
        set MainWidget.Item6Visibility = false
