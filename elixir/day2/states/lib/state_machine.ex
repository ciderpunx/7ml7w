defmodule StateMachine do
  defmacro __using__(_) do
    quote do
      import StateMachine
      @states []
      @before_compile StateMachine
    end
  end

  defmacro state(nm, evts) do
    # IO.puts "Declaring a state #{nm}"
    quote do
      @states [{unquote(nm), unquote(evts)} | @states]
    end
  end

  defmacro __before_compile__(env) do
    states = Module.get_attribute(env.module, :states)
    events = states 
             |> Keyword.values
             |> List.flatten
             |> Keyword.keys
             |> Enum.uniq

    quote do
      def state_machine do
        unquote(states)
      end

      unquote event_callbacks(events)
    end
  end

  def event_callback(nm) do
    callback = nm
    quote do
      def unquote(nm)(ctx) do
        StateMachine.Behaviour.fire(state_machine,ctx,unquote(callback))
      end
    end
  end

  def event_callbacks(nms) do
    Enum.map nms, &event_callback/1
  end
end
