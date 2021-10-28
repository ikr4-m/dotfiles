local tags = client.focus and client.focus.first_tag or nil

if tags == nil then
  return 0
else
  return tags.index
end
