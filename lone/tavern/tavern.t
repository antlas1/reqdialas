#include "soundlib.t" //библиотека звуковых игр
//Вводная к игре
modify intro
	desc = ""
;

//Информация по версии
modify version
	desc = "Версия 1.0"
;

//Каждая игра должна начинаться с 'startmenu'
startmenu: Menu
	desc = "Таверна бешеный кабанчик. Вы посмотрите на наше меню! Чтобы прочитать еще раз, нажмите F5."
	choices = "\t1. Начать игру.\n
		\t2. Побазарить с барменом."
	choice_1 = Gamescreen
choice_2 = instructions
;

instructions: Menu
	desc = "В нашей таверне вы можете не только приятно провести время за свои деньги, но и немного выпить за счёт заведения! Я вижу вас насквозь - у вас в кармане пусто, но наш бешеный кабанчик благосклонен к специалистам по выпивке! Теперь  Сначала вы с завязанными глазами должны узнать, сколько грамм я накапаю в стакан. Потом у вас будет только три секунды, чтобы сделать нужное количество глотков. Если не угадаешь, то получишь такую оплеуху от меня, что звездочки будут плясать джигу на твоём лбу! "
	choices = "\t1. Отодвинуться."
	choice_1 = startmenu
;

//Экран паузы
pausemenu: Menu
	desc = "Пауза"
	choices = "\t1. Продолжить игру.\n
		       \t2. Выйти из игры и перейти в главное меню."
	choice_1 = Gamescreen
	choice_2 = startmenu
;

finscreen: Menu
	desc = "Конец"
	choices = "\t1. Главное меню."
	choice_1 = startmenu
;

//Описание игровых состояний
class gamestate : object
   //public:
   glot = 1 //количество глотков
   //private:  
;

//управление персонажем на игровом экране
modify Controller0D
  doButton={
    if (global.currState) global.currState.onDrink;
  }
  startGame = {
    local start_snd := rand_from_list('bar_long_work.ogg','bar_long_water.ogg','bar_long_mind3.ogg','bar_long_life.ogg','bar_long_legs.ogg','bar_long_kiss.ogg','bar_long_friends.ogg','bar_long_between.ogg');
	play_sound_chan(start_snd,'AMBIENT');
	gameTimerInit.start;
  }
  pauseGame = {
    //" Установка паузы. ";//для отладки
    Me.location := pausemenu;
	pausemenu.see_choices := nil;
	Me.location.desc;
  }
;
/////////////////////////////
//Состояние для бара
barState : object
  delayNextSec = 0 //задержка на переход к следующему состоянию
random_sound=0 //Номер звука в списке,который будет выбераться случайно.
  wineFile = '' //какой звук звучит
  sounds=['wine1.ogg' 'wine1_2.ogg' 'wine2.ogg' 'wine2_2.ogg' 'wine3.ogg' 'wine3_2.ogg' 'wine5.ogg' 'wine5_2.ogg' 'wine10.ogg' 'wine10_2.ogg'] //Список звуков,из которых будет играть случайный звук в каждом игровом состоянии,кроме nil.
  numbers=[1 1 2 2 3 3 5 5 10 10] //сколько глотков обозначает каждый звук
  nextState = nil //следующее состояние
  etalDrinks = 0
doGame= { //Выбераем случайный звук для проигрывания и делаем количество глотков соответствующее этому звуку
self.random_sound:= rand_number_from_list(sounds);
self.etalDrinks:=numbers[random_sound];
self.wineFile:=sounds[random_sound];
}

  //private:
  delayWaitSec = 3 //сколько ждать набора
  delayFillSec = 2 //ожидание перед началам наливания
  userDrinks = 0
  startWait = nil
  
  onInit = {
    self.userDrinks := 0;
	self.startWait := nil;
    self.doGame;
  }
  
  onDrink={ //когда пытаемся выпить
     if (self.startWait){
	   self.userDrinks := self.userDrinks+1;
	   play_sound('drink.ogg');
	 }
	 else
	 {
		play_sound('negative.ogg'); //негативный ответ
	 }
	}
  onTimerNextState={ //таймер перехода к следующему
     local snd;
     //последнее состояние - проверяем и выигрываем или проигрываем
     if (self.nextState=nil){
	    if (self.etalDrinks = self.userDrinks){
		    snd := 'win_game.ogg';
		}
		else
		{
		    play_sound_chan('kick.ogg','AMBIENT');
		    snd := rand_from_list('bar_neg_what_say.ogg','bar_neg_respect.ogg','bar_neg_oh2.ogg','bar_neg_oh1.ogg','bar_neg_lucky.ogg','bar_neg_fight.ogg');
		}
play_sound(snd);
		endTimer.start;
	 }
	 else
	 {
	   if (self.etalDrinks = self.userDrinks){
	      gameTimerNextState.delay := self.nextState.delayNextSec*1000;
		  gameTimerStartWait.delay := (self.nextState.delayNextSec-self.nextState.delayWaitSec)*1000;
		  gameTimerStartFill.delay := self.delayFillSec*1000;
		  self.nextState.onInit;
		  global.currState := self.nextState;
		  play_sound_chan('complite.ogg','AMBIENT');
		  snd := rand_from_list('bar_ok_zasohnut.ogg','bar_ok_want_drink.ogg','bar_ok_want_beer.ogg','bar_ok_respect_me.ogg','bar_ok_quality.ogg','bar_ok_one_more.ogg');
		  play_sound(snd);
		  gameTimerStartWait.start;
		  gameTimerStartFill.start;
 		  gameTimerNextState.start;
	   }
	   else
	   {
	      snd := rand_from_list('bar_neg_what_say.ogg','bar_neg_respect.ogg','bar_neg_oh2.ogg','bar_neg_oh1.ogg','bar_neg_lucky.ogg','bar_neg_fight.ogg');
		  play_sound_chan('kick.ogg','AMBIENT');
		  play_sound(snd);
		  endTimer.start;
	   }
	 }
  }
  onTimerStartFill={
    play_sound(global.currState.wineFile);
  }
  onTimerStartWait={ //таймер начала ожидания ответа игрока
    self.startWait := true;
	play_sound('chok.ogg');
  }
;
barState1 : barState
  delayNextSec = 5
  nextState = barState2;

barState2: barState
  delayNextSec = 7
  delayWaitSec = 4
  nextState = barState3;
  
barState3 : barState
  delayNextSec = 15
  delayWaitSec = 6
  nextState = barState4;
  
barState4 : barState
  delayNextSec = 7
  nextState = barState5;
  
barState5 : barState
  delayNextSec = 10
  nextState = barState6;
  
barState6 : barState
  delayNextSec = 5
  nextState = nil;
  
//Таймер для озвучивания
gameTimerInit : Timer
  delay = 7000
  repeat = nil
  event = { 
    barState1.onInit;
    global.currState := barState1;
	gameTimerNextState.delay := barState1.delayNextSec*1000;
	gameTimerStartWait.delay := (barState1.delayNextSec-barState1.delayWaitSec)*1000;
	gameTimerNextState.start;
	gameTimerStartWait.start;
	play_sound(barState1.wineFile);
  }
;
gameTimerNextState : Timer
  event = { 
    if (global.currState<>nil) global.currState.onTimerNextState;
  }
;
gameTimerStartFill : Timer
  event = { 
    if (global.currState<>nil) global.currState.onTimerStartFill;
  }
;
gameTimerStartWait : Timer
  event = { 
    if (global.currState<>nil) global.currState.onTimerStartWait;
  }
;

endTimer : Timer
  delay = 2000
  repeat = nil
  event = { finishGame(finscreen); }
;


//////////////////////////////////////

//Глобальные флаги и значения для игры
modify global
    //системные параметры
    controller = Controller0D //контроллер для управления
	music_volume = 30 //громкость музыки
	intro_time_ms = 2000
	timers = [gameTimerInit gameTimerNextState gameTimerStartWait gameTimerStartFill endTimer] //таймеры для опроса
	//игровые параметры
	currState = nil
;