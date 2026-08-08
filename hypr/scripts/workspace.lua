hl.on("workspace.active", function(w)
    hl.exec_cmd("eww update current-workspace=" .. w.id)
end)
