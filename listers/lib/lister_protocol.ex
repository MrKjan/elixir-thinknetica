defprotocol ListerProtocol do
  @doc "Transforms data onto list"
  def to_list(data)
end

defimpl ListerProtocol, for: [List, Map, Range] do
  def to_list(data), do: Enum.to_list(data)
end

defimpl ListerProtocol, for: [Tuple] do
  def to_list(data), do: Tuple.to_list(data)
end

defimpl ListerProtocol, for: [Function] do
  def to_list(data), do: Function.info(data)
end

defimpl ListerProtocol, for: [Integer] do
  def to_list(data), do: Integer.digits(data)
end

defimpl ListerProtocol, for: [BitString] do
  def to_list(data), do: String.to_charlist(data)
end
