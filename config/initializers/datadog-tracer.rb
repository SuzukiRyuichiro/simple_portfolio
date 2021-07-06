Datadog.configure do |c|
  c.profiling.enabled = true
  c.env = 'product'
  c.service = 'login'
  c.version = '1.0.3'
end