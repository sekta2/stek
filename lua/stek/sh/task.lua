local Task = {
    pull = {},
    max_time = 0.003
}

function Task.Spawn(fn, ...)
    local co = coroutine.create(fn)
    Task.pull[#Task.pull + 1] = {
        co = co,
        cooldown = 0
    }
end

function Task.Yield()
    local co = coroutine.running()
    if not co then
        print("Task.Yield: called when not in coroutine")
        return
    end

    coroutine.yield()
end

function Task.Wait(ms)
    local co = coroutine.running()
    if not co then
        print("Task.Wait: called when not in coroutine")
        return
    end

    coroutine.yield(ms)
end

function Task.Update()
    if #Task.pull == 0 then return end

    local to_remove = {}
    local all_time = 0

    for i = 1, #Task.pull do
        local tsk = Task.pull[i]
        if tsk.cooldown > CurTime() then continue end

        local co = tsk.co

        if coroutine.status(co) == "dead" then
            to_remove[#to_remove + 1] = i
            continue
        end

        local time = SysTime()
        local success, res = coroutine.resume(co)
        all_time = all_time + (SysTime() - time)

        if not success then
            print("Task.Update: task failed by error: " .. res)
            to_remove[#to_remove + 1] = i

            continue
        end

        if type(res) == "number" then
            tsk.cooldown = CurTime() + res
            continue
        end

        if all_time >= Task.max_time then
            break
        end
    end

    for i = #to_remove, 1, -1 do
        local id = to_remove[i]
        table.remove(Task.pull, id)
    end

    print(all_time)
end

function Task.Init()
    hook.Add("Think", "stek.Task.Update", Task.Update)
end

stek.Task = Task
