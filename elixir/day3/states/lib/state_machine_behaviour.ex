defmodule StateMachine.Behaviour do
  import Enum

  def fire(ctx, evt) do
    %{ctx | state: evt[:to]} |> activate(evt)
  end

  def fire(states, ctx, evt_nm) do
    evt = states[ctx.state][evt_nm]
    fire(ctx, evt)
  end

  def activate(ctx, evt) do
    reduce(evt[:calls] || [], ctx, &(&1.(&2)))
  end
end
