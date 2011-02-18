class ShareWorker < BackgrounDRb::MetaWorker
  set_worker_name :share_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def del_share_expire
    logger.info 'Delete share expire'
  end
end