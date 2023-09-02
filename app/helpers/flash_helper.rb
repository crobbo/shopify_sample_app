module FlashHelper
  def classes_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      "bg-red-100 text-red-700"
    else
      "bg-green-100 text-green-700"
    end
  end
end