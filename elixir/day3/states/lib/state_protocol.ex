defprotocol StateProtocol do
    @fallback_to_any true # allows us to provide a default implementation
    def statey?(data)
end

# Provide a default implementation
# throws a KeyError if no state field in our struct
defimpl StateProtocol, for: Any do
  def statey?(s), do: s.state
end
