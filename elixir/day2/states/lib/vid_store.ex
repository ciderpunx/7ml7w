defmodule VidStore do
  use StateMachine

  state :available,
    rent:   [ to: :rented,    calls: [ &VidStore.renting/1 ]   ]

  state :rented,
    return: [ to: :available, calls: [ &VidStore.returning/1 ] ],
    lose:   [ to: :lost,      calls: [ &VidStore.losing/1 ]    ]

  state :lost, 
    find:   [ to: :rented,    calls: [ &VidStore.finding/1 ]   ]


  def before_return(v) do
    log v, "Before returning #{v.title}"
  end

  def renting(v) do
    vid = log v, "Renting #{v.title}"
    %{vid | times_rented: (v.times_rented+1)}
  end

  def returning(v) do
    log v, "Returning #{v.title}"
  end

  def after_return(v) do
    log v, "After returning #{v.title}"
  end

  def losing(v) do
    log v, "Losing #{v.title}"
  end

  def finding(v) do
    log v, "Finding #{v.title}"
  end

  def log(v,msg) do
    %{v | log: [msg <> "\n" |v.log]}
  end
end
