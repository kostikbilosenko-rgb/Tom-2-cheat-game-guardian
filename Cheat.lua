-- Проверка подключения GameGuardian
if not gg then 
    print("Ошибка: Скрипт предназначен только для GameGuardian!")
    os.exit() 
end

-- Функция для нахождения и изменения значений в памяти
function setStats(value)
    gg.clearResults()
    -- Поиск значений типа Float (обычно показатели хранятся в Float)
    gg.searchNumber(tostring(value), gg.TYPE_FLOAT)
    local count = gg.getResultCount()
    
    if count > 0 then
        local results = gg.getResults(count)
        for i, v in ipairs(results) do
            v.value = "100" -- Устанавливаем максимум
            v.freeze = false
        end
        gg.setValues(results)
        gg.toast("Показатели Тома обновлены!")
    else
        gg.alert("Показатели не найдены. Попробуйте изменить значение в игре и повторить.")
    end
end

-- Главное меню
function MAIN()
    local menu = gg.choice({
        "1. 🍖 Сделать все показатели на MAX (100%)",
        "2. ⚡ Увеличить уровень (Level Up)",
        "3. 📉 Понизить уровень",
        "4. ⬇️ Снизить все показатели (для проверки)",
        "❌ Выход"
    }, nil, "=== Мой Говорящий Том 2: Чит Меню ===")

    if menu == 1 then setMaxStats() end
    if menu == 2 then levelUp() end
    if menu == 3 then levelDown() end
    if menu == 4 then setMinStats() end
    if menu == 5 then os.exit() end
    
    gg.setVisible(true)
end

-- Максимальные показатели
function setMaxStats()
    gg.clearResults()
    -- Поиск типичных значений показателей (Float)
    gg.searchNumber("0.0~100.0", gg.TYPE_FLOAT)
    gg.alert("Инструкция: Скрипт ищет значения. Для точного взлома перейдите в игру, измените показатель и отсейте.")
end

-- Повысить уровень
function levelUp()
    gg.clearResults()
    local lvl = gg.prompt({"Введите ваш текущий уровень:"}, {[1]="1"}, {[1]="number"})
    if lvl == nil then return end
    
    gg.searchNumber(lvl[1], gg.TYPE_INT)
    local res = gg.getResults(100)
    
    if #res > 0 then
        local newLvl = tonumber(lvl[1]) + 5 -- Прибавляем 5 уровней
        for i, v in ipairs(res) do
            v.value = tostring(newLvl)
        end
        gg.setValues(res)
        gg.toast("Уровень изменен на: " .. newLvl)
    else
        gg.alert("Уровень не найден.")
    end
end

-- Понизить уровень
function levelDown()
    gg.clearResults()
    local lvl = gg.prompt({"Введите ваш текущий уровень:"}, {[1]="5"}, {[1]="number"})
    if lvl == nil then return end
    
    gg.searchNumber(lvl[1], gg.TYPE_INT)
    local res = gg.getResults(100)
    
    if #res > 0 then
        local newLvl = tonumber(lvl[1]) - 1
        if newLvl < 1 then newLvl = 1 end
        for i, v in ipairs(res) do
            v.value = tostring(newLvl)
        end
        gg.setValues(res)
        gg.toast("Уровень изменен на: " .. newLvl)
    else
        gg.alert("Уровень не найден.")
    end
end

-- Снизить показатели
function setMinStats()
    gg.toast("Функция понижения показателей запущена...")
end

-- Запуск цикла меню
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        MAIN()
    end
    gg.sleep(100)
end
