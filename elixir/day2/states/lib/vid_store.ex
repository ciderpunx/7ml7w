defmodule VidStore do
  use StateMachine

  state :available,
    rent:   [to: :rented,       calls: [ &VidStore.renting/1 ]]

  state :rented,
    return: [to: :available,    calls: [ &VidStore.returning/1 ]],
    lose:   [to: :lost,         calls: [ &VidStore.losing/1 ]]

  state :lost, []

  def renting(v) do
    vid = log v, "Renting #{v.title}"
    %{vid | times_rented: (v.times_rented+1)}
  end

  def returning(v) do
    log v, "Returning #{v.title}"
  end

  def losing(v) do
    log v, "Losing #{v.title}"
  end

  def log(v,msg) do
    %{v | log: [msg|v.log]}
  end
  
end
