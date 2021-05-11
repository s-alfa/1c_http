﻿
#Область АННОТАЦИЯ
// Дополнительные параметры (все ключи являются необязательными):
// {ОБЩИЕ}
//     Порт - Число - порт сервера, с которым производится соединение
//     Пользователь - Строка - пользователь, от имени которого устанавливается соединение
//     Пароль - Строка - пароль пользователя, от имени которого устанавливается соединение
//     Прокси - ИнтернетПрокси - прокси, через который устанавливается соединение
//     Таймаут - Число - определяет время ожидания осуществляемого соединения и операций, в секундах (0 - таймаут не установлен)
//     ЗащищенноеСоединение - ЗащищенноеСоединениеOpenSSL - объект защищенного соединения для осуществления HTTPS-соединения
//     ИспользоватьАутентификациюОС - Булево - указывает текущее значение использования аутентификации NTLM или Negotiate на сервере
//     Заголовки - Соответствие - заголовки запроса
//     Аутентификация - Структура - ключи: Пользователь, Пароль[, Тип]
//     НеИспользоватьПараметрыИзАдреса - наличие ключа указывает на игнорирование параметров из входящего адреса запроса
//     ПараметрыДублируются - наличие ключа позволяет указывать параметры несколько раз
//     ИмяВыходногоФайла - Строка - имя файла, в который помещаются данные полученного ресурса
// {POST}
//     Кодировка - КодировкаТекста, Строка - кодировка текста тела запроса
#КонецОбласти

#Область ЭКСПОРТНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ
// Реализация GET (выбрасывает исключения)
//
// Параметры:
//     ИдентификаторРесурса - Строка - URI сервиса или наименование описания внешнего сервиса | структура описания внешнего сервиса | ссылка на элемент справочника "Описание внешних сервисов и информационных баз"
//     ПараметрыЗапроса - Соответствие - коллекция параметров GET-запроса (необязательный)
//     ДополнительныеПараметры - Структура - структура дополнительных настроек POST-запроса (необязательный)
//
// Возвращаемые значения:
//     HTTPОтвет
//
Функция Получить(Знач ИдентификаторРесурса, Знач ПараметрыЗапроса = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	Если ПараметрыЗапроса = Неопределено Тогда
		ПараметрыЗапроса = Новый Соответствие;
	КонецЕсли;
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ДанныеURI = СтруктураИдентификатораРесурса(ИдентификаторРесурса);
	Параметры = ПараметрыЗапросаСтрокой(ДанныеURI, ПараметрыЗапроса, ДополнительныеПараметры);
	Заголовки = ЗаголовкиЗапроса(ДополнительныеПараметры);
	
	Соединение = НовоеHTTPСоединение(ДанныеURI, ДополнительныеПараметры);
	Запрос = Новый HTTPЗапрос(ДанныеURI.АдресРесурса + Параметры, Заголовки);
	
	Возврат Соединение.ПолучитьЗаголовки(Запрос);
КонецФункции

// Реализация HEAD
//
// Параметры:
//     ИдентификаторРесурса - Строка - URI сервиса или наименование описания внешнего сервиса | структура описания внешнего сервиса | ссылка на элемент справочника "Описание внешних сервисов и информационных баз"
//     ПараметрыЗапроса - Соответствие - коллекция параметров GET-запроса (необязательный)
//     ДополнительныеПараметры - Структура - структура дополнительных настроек POST-запроса (необязательный)
//
// Возвращаемые значения:
//     HTTPОтвет
//
Функция ПолучитьЗаголовки(Знач ИдентификаторРесурса, Знач ПараметрыЗапроса = Неопределено, Знач ДополнительныеПараметры = Неопределено) Экспорт
	Если ПараметрыЗапроса = Неопределено Тогда
		ПараметрыЗапроса = Новый Соответствие;
	КонецЕсли;
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ДанныеURI = СтруктураИдентификатораРесурса(ИдентификаторРесурса);
	Параметры = ПараметрыЗапросаСтрокой(ДанныеURI, ПараметрыЗапроса, ДополнительныеПараметры);
	Заголовки = ЗаголовкиЗапроса(ДополнительныеПараметры);
	
	Соединение = НовоеHTTPСоединение(ДанныеURI, ДополнительныеПараметры);
	Запрос = Новый HTTPЗапрос(ДанныеURI.АдресРесурса + Параметры, Заголовки);
	
	Возврат Соединение.Получить(Запрос);
КонецФункции

// Реализация POST
Функция ОтправитьТекст(Знач ИдентификаторРесурса, Знач Данные, Знач ДополнительныеПараметры = Неопределено, Знач ПараметрыЗапроса = Неопределено) Экспорт
	Если ПараметрыЗапроса = Неопределено Тогда
		ПараметрыЗапроса = Новый Соответствие;
	КонецЕсли;
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ДанныеURI = СтруктураИдентификатораРесурса(ИдентификаторРесурса);
	Параметры = ПараметрыЗапросаСтрокой(ДанныеURI, ПараметрыЗапроса, ДополнительныеПараметры);
	Заголовки = ЗаголовкиЗапроса(ДополнительныеПараметры);
	
	ДобавитьКодировкуВЗаголовкиЗапроса(Заголовки, ДополнительныеПараметры);
	ДобавитьРазмерДанныхВЗаголовкиЗапроса(Заголовки, ДополнительныеПараметры, Данные);
КонецФункции
#КонецОбласти


#Область СЛУЖЕБНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ
Функция СтруктураИдентификатораРесурса(Знач ИдентификаторРесурса)
	фРезультат = Новый Структура(
		"Сервер, АдресРесурса, Пользователь, Пароль, Порт, ЗащищенноеСоединение, Параметры",
		"",
		"/",
		"",
		"",
		80,
		Ложь,
		Неопределено
	);
	
	ПозицияНачалаПоиска = 8;
	
	Если СтрНачинаетсяС(ИдентификаторРесурса, "https://") Тогда
		ПозицияНачалаПоиска = 9;
		
		фРезультат.ЗащищенноеСоединение = Истина;
		фРезультат.Порт = 443;
	ИначеЕсли НЕ СтрНачинаетсяС(ИдентификаторРесурса, "http://") Тогда
		ВызватьИсключение "Не удалось разобрать URI";
	КонецЕсли;
	
	ДлинаИдентификатораРесурса = СтрДлина(ИдентификаторРесурса);
	ПозицияНачалаАдресаРесурса = СтрНайти(ИдентификаторРесурса, "/", , ПозицияНачалаПоиска);
	ПозицияНачалаСтрокиПараметров = СтрНайти(ИдентификаторРесурса, "?", , ПозицияНачалаПоиска); // допущение: пароль не содержит символ '?'
	
	Обращение = Сред(ИдентификаторРесурса, ПозицияНачалаПоиска, ?(ПозицияНачалаАдресаРесурса = 0, ПозицияНачалаСтрокиПараметров, ПозицияНачалаАдресаРесурса) - ПозицияНачалаПоиска);
	ДлинаОбращения = СтрДлина(Обращение);
	
	ПозицияПослеАвторизации = СтрНайти(Обращение, "@");
	Авторизация = Лев(Обращение, ПозицияПослеАвторизации - 1);
	ДлинаАвторизации = СтрДлина(Авторизация);
	Если ДлинаАвторизации > 0 Тогда
		ПозицияРазделителяАвторизации = СтрНайти(Авторизация, ":");
		ПозицияРазделителяАвторизации = ?(ПозицияРазделителяАвторизации = 0, ДлинаАвторизации + 1, ПозицияРазделителяАвторизации);
		
		фРезультат.Пользователь = СокрЛП(Лев(Авторизация, ПозицияРазделителяАвторизации - 1));
		фРезультат.Пароль       = Прав(Авторизация, ДлинаАвторизации - ПозицияРазделителяАвторизации); 	
	КонецЕсли;
	
	ИмяХоста = Прав(Обращение, ДлинаОбращения - ПозицияПослеАвторизации);
	
	ПозицияПорта = СтрНайти(ИмяХоста, ":");
	Если ПозицияПорта > 0 Тогда
		фРезультат.Порт = Число(Сред(ИмяХоста, ПозицияПорта + 1, ?(ПозицияНачалаАдресаРесурса = 0, ПозицияНачалаСтрокиПараметров - ПозицияНачалаПоиска, ПозицияНачалаАдресаРесурса) - ПозицияПорта));
	КонецЕсли;
	
	фРезультат.Сервер = ?(ПозицияПорта = 0, ИмяХоста, Лев(ИмяХоста, ПозицияПорта - 1));
	
	Если ПозицияНачалаАдресаРесурса > 0 Тогда
		фРезультат.АдресРесурса = Сред(
			ИдентификаторРесурса,
			ПозицияНачалаАдресаРесурса,
			?(
				ПозицияНачалаСтрокиПараметров = 0,
				ДлинаИдентификатораРесурса + 1,
				ПозицияНачалаСтрокиПараметров
			) - ПозицияНачалаАдресаРесурса
		);
	КонецЕсли;
	
	ЗначенияПараметров = Новый Соответствие;
	
	ПараметрыСтрока = ?(
		ПозицияНачалаСтрокиПараметров = 0,
		"",
		Прав(ИдентификаторРесурса, ДлинаИдентификатораРесурса - ПозицияНачалаСтрокиПараметров)
	);
	
	Параметры = СтрРазделить(ПараметрыСтрока, "&", Ложь);
	Для Каждого Параметр Из Параметры Цикл
		ПозицияРазделителя = СтрНайти(Параметр, "=");
		Если ПозицияРазделителя = 0 Тогда
			ПозицияРазделителя = СтрДлина(Параметр) + 1;
		КонецЕсли;
		
		ИмяПараметра = Лев(Параметр, ПозицияРазделителя - 1);
		Если Прав(ИмяПараметра, 2) = "[]" Тогда
			ИмяПараметра = Лев(ИмяПараметра, СтрДлина(ИмяПараметра)-2);
		КонецЕсли;
		Если ПустаяСтрока(ИмяПараметра) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеПараметра = Прав(Параметр, СтрДлина(Параметр) - ПозицияРазделителя);
		
		ТекущееЗначениеПараметра = ЗначенияПараметров.Получить(ИмяПараметра);
		Если ТекущееЗначениеПараметра = Неопределено Тогда
			ЗначенияПараметров.Вставить(ИмяПараметра, ЗначениеПараметра);
		Иначе
			Если ТипЗнч(ТекущееЗначениеПараметра) <> Тип("Массив") Тогда
				ЗначениеПараметраНаДобавление = ТекущееЗначениеПараметра;
				
				ТекущееЗначениеПараметра = Новый Массив;
				ТекущееЗначениеПараметра.Добавить(ЗначениеПараметраНаДобавление);
				
				ЗначенияПараметров.Вставить(ИмяПараметра, ТекущееЗначениеПараметра);
			КонецЕсли;
			
			ТекущееЗначениеПараметра.Добавить(ЗначениеПараметра);
		КонецЕсли;
	КонецЦикла;
	
	фРезультат.Параметры = ЗначенияПараметров;
	
	Возврат фРезультат;
КонецФункции

Функция НовоеHTTPСоединение(Знач ДанныеURI, Знач ДополнительныеПараметры)
	КонфигурацияСоединения = Новый Структура("Сервер", ДанныеURI.Сервер);
	
	Если НЕ ДополнительныеПараметры.Свойство("Порт") Тогда
		КонфигурацияСоединения.Вставить("Порт", ДанныеURI.Порт);
	КонецЕсли;
	Если НЕ ДополнительныеПараметры.Свойство("ЗащищенноеСоединение") И ДанныеURI.ЗащищенноеСоединение Тогда
		КонфигурацияСоединения.Вставить("ЗащищенноеСоединение", Новый ЗащищенноеСоединениеOpenSSL());
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ДанныеURI["Пользователь"]) Тогда
		КонфигурацияСоединения.Вставить("Пользователь", ДанныеURI.Пользователь);
		КонфигурацияСоединения.Вставить("Пароль",       ДанныеURI.Пароль);
	КонецЕсли;
	
	Для Каждого Ключ Из СтрРазделить("Пользователь,Пароль,Прокси,Таймаут,ИспользоватьАутентификациюОС", ",") Цикл
		Если ДополнительныеПараметры.Свойство("Пользователь") Тогда
			КонфигурацияСоединения.Вставить(Ключ, ДополнительныеПараметры[Ключ]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый HTTPСоединение(
		КонфигурацияСоединения.Сервер,
		КонфигурацияСоединения.Порт,
		?(КонфигурацияСоединения.Свойство("Пользователь"),                 КонфигурацияСоединения.Пользователь,                 ""),
		?(КонфигурацияСоединения.Свойство("Пароль"),                       КонфигурацияСоединения.Пароль,                       ""),
		?(КонфигурацияСоединения.Свойство("Прокси"),                       КонфигурацияСоединения.Прокси,                       Неопределено),
		?(КонфигурацияСоединения.Свойство("Таймаут"),                      КонфигурацияСоединения.Таймаут,                      0),
		?(КонфигурацияСоединения.Свойство("ЗащищенноеСоединение"),         КонфигурацияСоединения.ЗащищенноеСоединение,         Неопределено),
		?(КонфигурацияСоединения.Свойство("ИспользоватьАутентификациюОС"), КонфигурацияСоединения.ИспользоватьАутентификациюОС, Ложь)
	);
КонецФункции

Функция ПараметрыЗапросаСтрокой(Знач ДанныеURI, Знач ПараметрыЗапроса, Знач ДополнительныеПараметры)
	МножествоПараметров = Новый Соответствие;
	
	Для Каждого КЗ Из ДанныеURI.Параметры Цикл
		МножествоПараметров.Вставить(КЗ.Ключ, КЗ.Значение);
	КонецЦикла;
	
	Если НЕ ДополнительныеПараметры.Свойство("НеИспользоватьПараметрыИзИдентификатораРесурса") Тогда
		Для Каждого КЗ Из ПараметрыЗапроса Цикл
			МножествоПараметров.Вставить(КЗ.Ключ, КЗ.Значение);
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыДублируются = ДополнительныеПараметры.Свойство("ПараметрыДублируются");
	СуффиксИмениПараметра = ?(ДополнительныеПараметры.Свойство("СтильДублирующихсяПараметровPHP"), "[]", "");
	ЧастиСтроки = Новый Массив;
	
	Для Каждого КЗ Из МножествоПараметров Цикл
		Если ТипЗнч(КЗ.Значение) = Тип("Массив") Тогда
			Если ПараметрыДублируются Тогда
				Для Каждого ЗначениеПараметра Из КЗ.Значение Цикл
					ЧастиСтроки.Добавить(КЗ.Ключ + СуффиксИмениПараметра + "=" + ЗначениеПараметра);
				КонецЦикла;
			Иначе
				ЧастиСтроки.Добавить(КЗ.Ключ + "=" + КЗ.Значение[КЗ.Значение.Количество()-1]);
			КонецЕсли;
		Иначе
			ЧастиСтроки.Добавить(КЗ.Ключ + "=" + КЗ.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ?(ЧастиСтроки.Количество() = 0, "", "?" + СтрСоединить(ЧастиСтроки, "&"));
КонецФункции

Функция ЗаголовкиЗапроса(Знач ДополнительныеПараметры)
	фРезультат = Новый Соответствие;
	
	Если ДополнительныеПараметры.Свойство("Заголовки") Тогда
		Для Каждого КЗ Из ДополнительныеПараметры.Заголовки Цикл
			фРезультат.Вставить(КЗ.Ключ, КЗ.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("Аутентификация") И ДополнительныеПараметры.Аутентификация.Свойство("Тип") Тогда
		Если ДополнительныеПараметры.Аутентификация.Тип = "Basic" Тогда
			ДобавитьBasicАутентификациюВЗаголовкиЗапроса(фРезультат, ДополнительныеПараметры.Аутентификация);
		ИначеЕсли ДополнительныеПараметры.Аутентификация.Тип = "NTLM" Тогда
			ДополнительныеПараметры.Вставить("ИспользоватьАутентификациюОС", Истина);
			ДополнительныеПараметры.Вставить("Пользователь",                 ДополнительныеПараметры.Аутентификация.Пользователь);
			ДополнительныеПараметры.Вставить("Пароль",                       ДополнительныеПараметры.Аутентификация.Пароль);
		КонецЕсли;
	КонецЕсли;
	
	Возврат фРезультат;
КонецФункции

Процедура ДобавитьBasicАутентификациюВЗаголовкиЗапроса(Заголовки, Знач ДанныеАутентификации)
	СтрокаАутентификации = РаботаСHttpСлужебный.СтрокаBasicАвторизации(ДанныеАутентификации.Пользователь, ДанныеАутентификации.Пароль);
	
	Заголовки.Вставить("Authorization", "Basic " + СтрокаАутентификации);
КонецПроцедуры

Функция КодировкаИзПараметров(Знач ДополнительныеПараметры)
	Возврат ?(ДополнительныеПараметры.Свойство("Кодировка"), ДополнительныеПараметры.Кодировка, РаботаСHttpПовтИсп.КодировкаПоУмолчанию());
КонецФункции

Процедура ДобавитьКодировкуВЗаголовкиЗапроса(Заголовки, Знач ДополнительныеПараметры)
	Кодировка = КодировкаИзПараметров(ДополнительныеПараметры);
	Если Заголовки.Получить("Content-Type") <> Неопределено Тогда
		Заголовки.Вставить("Content-Type", Заголовки.Получить("Content-Type") + "; charset=" + Кодировка);
	КонецЕсли;
КонецПроцедуры

Процедура ДобавитьРазмерДанныхВЗаголовкиЗапроса(Заголовки, Знач ДополнительныеПараметры, Знач Данные)
	Кодировка = КодировкаИзПараметров(ДополнительныеПараметры);
	Заголовки.Вставить("Content-Lenght", РаботаСHttpСлужебный.РазмерТекстовыхДанных(Данные, Кодировка));
КонецПроцедуры
#КонецОбласти
