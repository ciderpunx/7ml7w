defmodule Should do
  defmacro should(nm,opts) do
    quote do
      test("should #{unquote nm}", unquote(opts))
    end
  end
end
ExUnit.start()
