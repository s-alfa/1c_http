﻿
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	
	ИР = Параметры.ИдентификаторРесурса;
	
	ЗащищенноеСоединение = СтрНачинаетсяС(ИР, "https://");
	Если ЗащищенноеСоединение Тогда
		Элементы.ДекорацияСхема.Заголовок = "https://";
		Элементы.ДекорацияСхемаМП.Заголовок = "https://";
	КонецЕсли;
	
	ИР = СтрЗаменить(ИР, "https://", "");
	ИР = СтрЗаменить(ИР, "http://", "");
	ПозицияОкончания = СтрНайти(ИР, "?") - 1;
	Если ПозицияОкончания < 0 Тогда
		ПозицияОкончания = СтрДлина(ИР);
	КонецЕсли;
	
	ПозицияПослеАвторизации = СтрНайти(ИР, "@");
	Если ПозицияПослеАвторизации > 0 И ПозицияПослеАвторизации < ПозицияОкончания Тогда
		Авторизация = Лев(ИР, ПозицияПослеАвторизации - 1);
		ДлинаАвторизации = СтрДлина(Авторизация);
		ПозицияРазделителяАвторизации = СтрНайти(Авторизация, ":");
		Если ПозицияРазделителяАвторизации = 0 Тогда
			ПозицияРазделителяАвторизации = ДлинаАвторизации + 1;
		КонецЕсли;
		
		ЗакодированныеДанные = Новый Структура("Пользователь, Пароль");
		ЗакодированныеДанные.Пользователь = СокрЛП(Лев(Авторизация, ПозицияРазделителяАвторизации - 1));
		ЗакодированныеДанные.Пароль = Прав(Авторизация, ДлинаАвторизации - ПозицияРазделителяАвторизации);
		РаскодированныеДанные = КлиентHTTP.РаскодированныеСтроки(ЗакодированныеДанные);
		
		Пользователь = РаскодированныеДанные.Пользователь;
		Пароль = РаскодированныеДанные.Пароль;
		ИР = Сред(ИР, ПозицияПослеАвторизации + 1);
		ПозицияОкончания = СтрДлина(ИР);
	КонецЕсли;
	
	ПозицияАдресаРесурса = СтрНайти(ИР, "/");
	Если ПозицияАдресаРесурса > 0 Тогда
		АдресРесурса = Сред(ИР, ПозицияАдресаРесурса, ПозицияОкончания - ПозицияАдресаРесурса + 1);
		ПозицияОкончания = ПозицияАдресаРесурса - 1;
	КонецЕсли;
	
	ПозицияПорта = СтрНайти(ИР, ":", НаправлениеПоиска.СКонца, ПозицияОкончания);
	Если ПозицияПорта > 0 Тогда
		Порт = ОписаниеТипаЧисло.ПривестиЗначение(Сред(ИР, ПозицияПорта + 1, ПозицияОкончания));
		ПозицияОкончания = ПозицияПорта - 1;
	Иначе
		Порт = ?(ЗащищенноеСоединение, 443, 80);
	КонецЕсли;
	
	Сервер = Лев(ИР, ПозицияОкончания);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	URI = ИдентификаторРесурса();
	
#Если МобильныйКлиент Тогда
	Элементы.Основная.Видимость = Ложь;
	Элементы.ФормаОК.Видимость = Ложь;
	Элементы.ОсновнаяМП.Видимость = Истина;
#КонецЕсли
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ОК(Команда)
	Перем ПроверяемоеПоле;
	
#Если МобильныйКлиент Тогда
	ПроверяемоеПоле = "СерверМП";
#Иначе
	ПроверяемоеПоле = "Сервер";
#КонецЕсли
	
	Если ПустаяСтрока(Сервер) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Укажите имя хоста";
		Сообщение.Поле = ПроверяемоеПоле;
		Сообщение.Сообщить();
		
		Возврат;
	КонецЕсли;
	
	Закрыть(ИдентификаторРесурса());
КонецПроцедуры
#КонецОбласти

#Область ПЕРСОНАЛЬНЫЙ_КОМПЬЮТЕР
#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ЗащищенноеСоединениеПриИзменении(Элемент)
	ОформитьЗащищенноеСоединение(Элементы.ДекорацияСхема);
	
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура СерверПриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПортПриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура АдресРесурсаПриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры
#КонецОбласти
#КонецОбласти

#Область МОБИЛЬНОЕ_УСТРОЙСТВО
&НаКлиенте
Процедура ЗащищенноеСоединениеМППриИзменении(Элемент)
	ОформитьЗащищенноеСоединение(Элементы.ДекорацияСхемаМП);
	
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура СерверМППриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПортМППриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура АдресРесурсаМППриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПользовательМППриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПарольМППриИзменении(Элемент)
	URI = ИдентификаторРесурса();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Функция ИдентификаторРесурса()
	ЧастиURL = Новый Массив;
	ЧастиURL.Добавить(?(ЗащищенноеСоединение, "https://", "http://"));
	
	Если НЕ ПустаяСтрока(Пользователь) Тогда
		КоллекцияСтрок = Новый Структура("Пользователь, Пароль", Пользователь, Пароль);
		ЗакодированныеДанные = ЗакодированныеСтроки(КоллекцияСтрок);
		
		ЧастиURL.Добавить(ЗакодированныеДанные.Пользователь);
		Если НЕ ПустаяСтрока(ЗакодированныеДанные.Пароль) Тогда
			ЧастиURL.Добавить(":");
			ЧастиURL.Добавить(ЗакодированныеДанные.Пароль);
		КонецЕсли;
		ЧастиURL.Добавить("@");
	КонецЕсли;
	
	ЧастиURL.Добавить(СокрЛП(Сервер));
	
	Если ЗащищенноеСоединение И Порт <> 443 ИЛИ НЕ ЗащищенноеСоединение И Порт <> 80 Тогда
		ЧастиURL.Добавить(":");
		ЧастиURL.Добавить(XMLСтрока(Порт));
	КонецЕсли;
	
	АдресРесурса = СокрЛП(АдресРесурса);
	Если НЕ ПустаяСтрока(АдресРесурса) И НЕ СтрНачинаетсяС(АдресРесурса, "/") Тогда
		ЧастиURL.Добавить("/");
	КонецЕсли;
	
	ЧастиURL.Добавить(АдресРесурса);
	
	Возврат СтрСоединить(ЧастиURL);
КонецФункции

&НаКлиенте
Процедура ОформитьЗащищенноеСоединение(ЭлементСхемы)
	Если ЗащищенноеСоединение Тогда
		ЭлементСхемы.Заголовок = "https://";
		
		Если Порт = 80 Тогда
			Порт = 443;
		КонецЕсли;
	Иначе
		ЭлементСхемы.Заголовок = "http://";
		
		Если Порт = 443 Тогда
			Порт = 80;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗакодированныеСтроки(Знач КоллекцияСтрок)
	Возврат КлиентHTTP.ЗакодированныеСтроки(КоллекцияСтрок, СпособКодированияСтроки.КодировкаURL);
КонецФункции
#КонецОбласти
