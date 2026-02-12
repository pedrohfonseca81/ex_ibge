defmodule ExIbge.Bngb.DictionaryEntry do
  @moduledoc """
  Struct representing a BNGB dictionary entry with translations.
  """

  defstruct [:term, :label_en, :label_es, :label_pt]

  @type t :: %__MODULE__{
          term: String.t() | nil,
          label_en: String.t() | nil,
          label_es: String.t() | nil,
          label_pt: String.t() | nil
        }

  @spec from_entry({String.t(), map()} | nil) :: t() | nil
  def from_entry(nil), do: nil

  def from_entry({term, labels}) do
    %__MODULE__{
      term: term,
      label_en: labels["label_en"],
      label_es: labels["label_es"],
      label_pt: labels["label_pt"]
    }
  end
end
