event_user(0);

// UI 与状态控制
ButtonList = [];
Index      = 0;
State      = -1;
State_Next = BATTLE.STATE.MENU;
Menu       = -1;
Menu_Now   = -1;

// 战斗实体列表
EnemyList = [];
TurnList  = [];
Turn      = 0;

// 对话与交互
Dialog       = noone;
MenuDiglog   = Encounter_Invoke(Encounter_InvokeID(), "MenuDiglog");
DescribeInst = noone;

// 动画与伤害
AnimTime     = 0;
DamageTime   = 0;
Damage       = 0;

// 奖励
RewardExp = 0;
RewardGold = 0;

// 其他标志
Fell = true;

// 临时数据
TempText   = [];
TempButton = array_create(2, 0);

// 队列初始化
Queue_Create("Dialog");