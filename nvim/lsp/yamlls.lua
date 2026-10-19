return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git" },
  settings = {
    -- Turn off schema-store fetching unless a project opts in via
    -- .yaml.schemas / yaml.schemas settings; avoids network noise.
    yaml = { schemaStore = { enable = false } },
  },
}
