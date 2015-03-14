defmodule Video do
  defstruct title: "", state: :available, times_rented: 0, log: []
end

# Implement our state protocol
# Inherit default implementation
defimpl StateProtocol, for: Video do
    def statey?(s), do: s.state
end
