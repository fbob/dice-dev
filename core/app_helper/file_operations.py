import os
import shutil


class FileOperations:
    """
    Helper class for BasicApp with basic file operations.
    """
    @staticmethod
    def rmtree(path, ignore_errors=True):
        shutil.rmtree(path, ignore_errors)

    @staticmethod
    def rm(path):
        os.unlink(path)

    def clear_folder_content(self, path):
        self.rmtree(path)
        self.make_dir(path)

    @staticmethod
    def move(src, dst):
        shutil.move(src, dst)

    @staticmethod
    def make_dir(dir, exist_ok=True, ignore_errors=True):
        if ignore_errors:
            try:
                os.makedirs(dir, exist_ok=exist_ok)
            except:
                pass
        else:
            os.makedirs(dir, exist_ok=exist_ok)

    @staticmethod
    def parse_url(url):
        if url.startswith("file://"):
            url = url[7:]
        return url

    @staticmethod
    def touch(file_name, times=None):
        with open(file_name, 'a'):
            os.utime(file_name, times)

    @staticmethod
    def copy_merge(src, dst):
        """
        Merges a directory from src into dst by copying src into dst.
        If a file in dst already exists, it is overwritten by the file in src.
        Directories inside src are handled recursively.
        """
        if not os.path.exists(dst):
            FileOperations.make_dir(dst)

        src_list = os.listdir(src)
        dst_list = os.listdir(dst)

        for f in src_list:
            dst_path = os.path.join(dst, f)
            src_path = os.path.join(src, f)
            if os.path.exists(dst_path):
                if os.path.isdir(dst_path):
                    FileOperations.copy_merge(src_path, dst_path)
                else:
                    # os.unlink(dst_path)
                    # shutil.copy overwrites files by itself
                    shutil.copy(src_path, dst_path)
            else:
                FileOperations.copy(src_path, dst_path) # copy regardless of src_path being a file or directory

    @staticmethod
    def copy(src, dst, merge = False):
        # need to trim src if it has a trailing /, basename will fail otherwise
        if src[-1] == "/": src = src[:-1]
        src_base = os.path.basename(src)
        src_in_dst = os.path.join(dst, src_base)

        if not os.path.exists(dst):
            FileOperations.make_dir(dst)

        if merge:
            FileOperations.copy_merge(src, src_in_dst)
            return

        if os.path.isdir(src):
            shutil.copytree(src, src_in_dst)
        else:
            shutil.copy(src, dst)

    @staticmethod
    def copy_folder_content(src, dest, ignore=None, overwrite=False):
        if os.path.isdir(src):
            if not os.path.isdir(dest):
                os.makedirs(dest)
            files = os.listdir(src)
            if ignore is not None:
                ignored = ignore(src, files)
            else:
                ignored = set()
            for f in files:
                if f not in ignored:
                    FileOperations.copy_folder_content(os.path.join(src, f),
                                             os.path.join(dest, f),
                                             ignore, overwrite=overwrite)
        else:
            if overwrite or not os.path.isfile(dest):
                shutil.copyfile(src, dest)