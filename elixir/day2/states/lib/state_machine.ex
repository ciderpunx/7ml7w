defmodule StateMachine do
  defmacro __using__(_) do
    quote do
      import StateMachine
      import StateProtocol

      @states []
      @before_compile StateMachine
    end
  end

  defmacro state(nm, evts) do
    quote do
      @states [{unquote(nm), unquote(evts)} | @states]
    end
  end

  defmacro __before_compile__(env) do
    mod    = env.module
    states = Module.get_attribute(mod, :states)
    events = states 
             |> Keyword.values
             |> List.flatten
             |> Keyword.keys
             |> Enum.uniq

    quote do

      def state_machine do
        unquote(states)
      end

      unquote event_callbacks(events,mod)
    end
  end

  def event_callback(nm,mod) do
    callback = nm
    quote do
      def unquote(nm)(ctx) do
        StateProtocol.statey?(ctx)
        ctx1 = hook(unquote(mod), unquote(nm),"before_",ctx) 
        ctx2 = StateMachine.Behaviour.fire(state_machine,ctx1,unquote(callback))
        ctx3 = hook(unquote(mod), unquote(nm),"after_",ctx2)
      end
    end
  end

  def hook(mod,nm,whn,ctx) do
    func_name = whn <> to_string(nm)
    func = String.to_atom(func_name)
    if Kernel.function_exported?(mod, func, 1) do
      apply(mod, func, [ctx])
    else
      ctx
    end
  end

  def event_callbacks(nms,mod) do
    Enum.map nms,  fn x -> event_callback(x,mod) end
  end
end
