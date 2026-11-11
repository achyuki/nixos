final: prev: {
  # dwarfs 0.15.8 的 dwarfsextract_format_test 在 pwb/raw/xar 上 abort：
  # filesystem_extractor::close() 在 archive_write_close 抛异常时跳过了
  # 管道 I/O 线程的 join，unique_ptr<std::thread> 析构 joinable 线程触发
  # std::terminate。gearlever 依赖 dwarfs，因此整个包构建失败。
  # 上游修复后可移除本 overlay。
  dwarfs = prev.dwarfs.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/dwarfs-pipe-join.patch ];
  });
}
