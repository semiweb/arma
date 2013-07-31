module InstallationHelper

  def separator(*args)
    count = args.join('').size + 7
    '-' * (50 - count)
  end

end
