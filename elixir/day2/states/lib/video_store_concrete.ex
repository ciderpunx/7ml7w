defmodule VideoStore.Concrete do
  import StateMachine.Behaviour
  def rent(v),   do: fire(state_machine, v, :rent)
  def return(v), do: fire(state_machine, v, :return)
  def lose(v),   do: fire(state_machine, v, :lose)
  def find(v),   do: fire(state_machine, v, :find)
  def state_machine do
    [ available: 
        [ rent:   [ to: :rented, calls: [&VideoStore.renting/1]] ],
      rented: 
        [ return: [ to: :available, calls: [&VideoStore.returning/1] ],
          lose:   [ to: :lost, calls: [&VideoStore.losing/1] ]
        ],
      lost:
        [ find: [ to: :rented, calls: [&VideoStore.finding/1]] ]
    ]
  end
end
