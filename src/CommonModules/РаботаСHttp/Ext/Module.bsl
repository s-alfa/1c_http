﻿
#Область ЭКСПОРТНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ
// Возвращает: объект HTTPОтвет
//
// Параметры:
//     ИдентификаторРесурса - Строка - URI сервиса или наименование описания внешнего сервиса | структура описания внешнего сервиса | ссылка на элемент справочника "Описание внешних сервисов и информационных баз"
//     ПараметрыЗапроса - Соответствие - коллекция параметров GET-запроса (необязательный)
//
// Возвращаемые значения:
//     HTTPОтвет
//
Функция Получить(Знач ИдентификаторРесурса, ПараметрыЗапроса) Экспорт
	ВызватьИсключение "Функция ""Получить"" в разработке...";
КонецФункции
#КонецОбласти


#Область СЛУЖЕБНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ
//
#КонецОбласти
