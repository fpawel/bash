#!/bin/bash

# Установка локали для ускорения работы
export LC_ALL=C

# Парсим именованные аргументы
START_TIME=""
END_TIME=""

for arg in "$@"; do
  case $arg in
    --start=*)
      START_TIME="${arg#*=}"
      ;;
    --end=*)
      END_TIME="${arg#*=}"
      ;;
    *)
      echo "Неизвестный аргумент: $arg"
      echo "Использование: $0 [--start=YYYY-MM-DDTHH:MM:SS] [--end=YYYY-MM-DDTHH:MM:SS]"
      exit 1
      ;;
  esac
done

# Формируем AWK-скрипт
gawk '
{
    # Ищем подстроку "T":"..." в строке
    start = index($0, "\"T\":\"")
    if (start == 0)
        next

    # Вырезаем временную метку до секунд: "2025-06-09T00:06:55"
    time_str = substr($0, start + 5, 19)

    # Проверяем временные границы
    valid = 1

    # Начало времени (если указано)
    if ("'"${START_TIME}"'" != "" && time_str < "'"${START_TIME}"'")
        valid = 0

    # Конец времени (если указано)
    if ("'"${END_TIME}"'" != "" && time_str > "'"${END_TIME}"'")
        valid = 0

    if (valid)
        print
}' /dev/stdin