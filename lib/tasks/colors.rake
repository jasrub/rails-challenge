namespace :colors do
  desc "Add colors to the database"
  task add_colors: :environment do
    primary = Color.create(name: 'primary')
    danger = Color.create(name: 'danger')
    success = Color.create(name: 'success')
    info = Color.create(name: 'info')
    warning = Color.create(name: 'warning')
  end

  desc "Assign the qualities created on seed to colors. This assumes nothing was added to data except seed"
  task assign: :environment do
    purpose = CreativeQuality.where(name: "Purpose").first
    purpose.color = Color.where(name: "primary").first
    purpose.save
    
    empowerment = CreativeQuality.where(name: "Empowerment").first
    empowerment.color = Color.where(name: "danger").first
    empowerment.save
    
    collaboration = CreativeQuality.where(name: "Collaboration").first
    collaboration.color = Color.where(name: "success").first
    collaboration.save
  end

end
