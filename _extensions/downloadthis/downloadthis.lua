local str = pandoc.utils.stringify
local p = quarto.log.output

local function ensureHtmlDeps()
  quarto.doc.add_html_dependency({
    name = "downloadthis",
    version = "1.9.1",
    stylesheets = {"resources/css/downloadthis.css"}
  })
end

local function optional(arg, default)
  if arg == nil or arg == ""
  then
    return default
  else
    return arg
  end
end

function import(script)
  local path = PANDOC_SCRIPT_FILE:match("(.*[/\\])") .. "resources/lua/"
  package.path = path .. script .. ";" .. package.path
  return require(script)
end

local b64 = import('base64.lua')
local puremagic = import('puremagic.lua')

return {
  ['downloadthis'] = function(args, kwargs, meta) 
    
    -- args and kwargs    
    local file_path = str(args[1])
    local extension = "." .. file_path:match("[^.]+$")
    local dname = optional(str(kwargs["dname"]), "file")
    local dfilename = dname .. extension
    local btn_label = " " .. optional(str(kwargs["label"]), "Download") .. " "
    local btn_type = optional(str(kwargs["type"]), "default")
    local icon = optional(str(kwargs["icon"]), "download")
    local class = " " .. optional(str(kwargs["class"]), "")
    local rand = "dnldts" .. str(math.random(1, 65000))
    local id = optional(str(kwargs["id"]), rand)
    -- reading files
    local fh = io.open(file_path, "rb")
    if not fh then
        io.stderr:write("Cannot open file " .. 
          file_path .. 
          " | Skipping adding buttons\n")
        return pandoc.Null()
    else
      local contents = fh:read("*all")
      fh:close()
      
      -- creating dataURI object
      local b64_encoded = b64.encode(contents)
      local mimetype = puremagic.via_path(file_path)
      local data_uri = 'data:' .. mimetype .. ";base64," .. b64_encoded
      
      -- js code 
      local js = [[fetch('%s').then(res => res.blob()).then(blob => {
      const downloadURL = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      document.body.appendChild(a);
      a.href = downloadURL;
      a.download = '%s'; a.click();
      window.URL.revokeObjectURL(downloadURL);
      document.body.removeChild(a);
        });]]
      
      local clicked = js:format(data_uri, dfilename)
      
      -- creating button
      local button = 
          "<button class=\"btn btn-" .. btn_type .. " downloadthis " .. 
          class .. "\"" ..
          " id=\"" .. id .. "\"" ..
          "><i class=\"bi bi-" .. icon .. "\"" .. "></i>" ..
          btn_label .. 
          "</button>"
      if quarto.doc.is_format("html:js") and quarto.doc.has_bootstrap()
      then
        ensureHtmlDeps()
        return pandoc.RawInline('html',
        "<a href=\"#" .. id .. "\"" ..
        " onclick=\"" .. clicked .. "\">" .. button .. "</a>"
        )
      else
        return pandoc.Null()
      end
    end
  end
}

