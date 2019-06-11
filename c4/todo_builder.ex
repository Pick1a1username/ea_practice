defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list_acc -> add_entry(todo_list_acc, entry) end
    )
  end

  def add_entry(todo_list, entry) do
    # Set the new entry's id
    entry = Map.put(entry, :id, todo_list.auto_id)
    
    # Add the new entry to the entries list
    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    # Update the struct
    %TodoList{todo_list |
      entries: new_entries,
      auto_id: todo_list.auto_id + 1
    }
  end

  def entries(todo_list, date) do
    # Map.get(todo_list, date, [])

    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error -> todo_list
      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
	new_entries = Map.put(
	  todo_list.entries,
	  new_entry.id,
	  new_entry
	)
	%TodoList{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ ->new_entry end)
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list |
      entries: Map.delete(todo_list.entries, entry_id),
      auto_id: todo_list.auto_id
    }
  end
end

defmodule MultiDict do
  def new(), do: %{}

  def add(dict, key, value) do
    Map.update(dict, key, [value], &[value | &1])
  end

  def get(dict, key) do
    Map.get(dict, key, [])
  end
end
