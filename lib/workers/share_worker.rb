class ShareWorker < BackgrounDRb::MetaWorker
  set_worker_name :share_worker
  reload_on_schedule true
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def del_share_expire
    share_files = ShareFile.find(:all, :conditions => ["created_at < ?", Time.now - 1.week])
    share_files.delete_all
    logger.info 'Delete share expire'
  end
end