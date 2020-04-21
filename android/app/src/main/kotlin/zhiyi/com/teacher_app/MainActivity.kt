package zhiyi.com.teacher_app

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import com.pgyersdk.update.DownloadFileListener
import com.pgyersdk.update.PgyUpdateManager
import com.pgyersdk.update.UpdateManagerListener
import com.pgyersdk.update.javabean.AppBean

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity: FlutterActivity() {

  //读写权限
  private val PERMISSIONS_STORAGE = arrayOf(
          Manifest.permission.READ_EXTERNAL_STORAGE,
          Manifest.permission.WRITE_EXTERNAL_STORAGE
  )
  //请求状态码
  private val REQUEST_PERMISSION_CODE = 1

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    update()

    if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
      if (ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(this, PERMISSIONS_STORAGE, REQUEST_PERMISSION_CODE)
      }
    }
  }
  private fun checkMyPermission() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      if (!Settings.canDrawOverlays(this)) {
        val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
        )
        return startActivityForResult(intent, 1)
      }
    }
  }

  fun update(){
    /** 新版本 **/
    /** 新版本  */
    PgyUpdateManager.Builder()
            .setForced(true) //设置是否强制提示更新,非自定义回调更新接口此方法有用
            .setUserCanRetry(false) //失败后是否提示重新下载，非自定义下载 apk 回调此方法有用
            .setDeleteHistroyApk(false) // 检查更新前是否删除本地历史 Apk， 默认为true
            .setUpdateManagerListener(object : UpdateManagerListener {
              override fun onNoUpdateAvailable() {
                //没有更新是回调此方法
                Log.d("PGY", "没有新版本")
              }
              override fun onUpdateAvailable(appBean: AppBean) {
                //有更新回调此方法
                Log.d(
                        "PGY", "有新版本可以更新  新版本代码为 " + appBean.versionCode
                )
                //调用以下方法，DownloadFileListener 才有效；
                //如果完全使用自己的下载方法，不需要设置DownloadFileListener
                PgyUpdateManager.downLoadApk(appBean.downloadURL)
              }
              override fun checkUpdateFailed(e: Exception) {
                //更新检测失败回调
                //更新拒绝（应用被下架，过期，不在安装有效期，下载次数用尽）以及无网络情况会调用此接口
                Log.e("PGY", "检查更新失败", e)
              }
            }) //注意 ：
            //下载方法调用 PgyUpdateManager.downLoadApk(appBean.getDownloadURL()); 此回调才有效
            //此方法是方便用户自己实现下载进度和状态的 UI 提供的回调
            //想要使用蒲公英的默认下载进度的UI则不设置此方法
            .setDownloadFileListener(object : DownloadFileListener {
              override fun downloadFailed() {
                //下载失败
                Log.e("PGY", "下载apk失败")
              }
              override fun onProgressUpdate(vararg p0: Int?) {
                Log.e("PGY", "更新下载apk进度" + p0[0])
              }
              override fun downloadSuccessful(file: File?) {
                Log.e("PGY", "下载成功的apk")
                // 使用蒲公英提供的安装方法提示用户 安装apk
                PgyUpdateManager.installApk(file)
              }
            }).register()
  }
  override fun onRequestPermissionsResult(
          requestCode: Int,
          permissions: Array<String>,
          grantResults: IntArray
  ) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    if (requestCode == REQUEST_PERMISSION_CODE) {
      for (i in permissions.indices) {
        Log.i(
                "MainActivity",
                "申请的权限为：" + permissions[i] + ",申请结果：" + grantResults[i]
        )
      }
    }
  }
}
