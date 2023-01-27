local data = {}

local class = {}

function class.getState()
  return data.state
end

function class.setState(value)
  data.state = value
end

function class.load()
  data.state = "intro"
end

return class