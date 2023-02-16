###
### Copyright (C) 2022 Intel Corporation
###
### SPDX-License-Identifier: BSD-3-Clause
###

from .....lib import *
from .....lib.ffmpeg.vaapi.util import *
from .....lib.ffmpeg.vaapi.encoder import EncoderTest

from ...util import BDRateMixin

spec = load_test_spec("avc", "encode", "8bit")

@slash.requires(*have_ffmpeg_encoder("h264_vaapi"))
class AVCEncoderBaseTest(EncoderTest, BDRateMixin):
  def before(self):
    super().before()
    vars(self).update(
      codec = "avc",
      ffenc = "h264_vaapi",
    )

  def get_file_ext(self):
    return "h264"

  def get_vaapi_profile(self):
    return {
      "high"                  : "VAProfileH264High",
      "main"                  : "VAProfileH264Main",
      "constrained-baseline"  : "VAProfileH264ConstrainedBaseline",
    }[self.profile]

  def check_metrics(self):
    self.decoder.update(source = self.encoder.encoded)
    self.decoder.decode()

    encsize = os.path.getsize(self.encoder.encoded)
    bitrate = encsize * 8 * vars(self).get("fps", 25) / 1024.0 / self.frames
    psnr = calculate_psnr(
      self.source, self.decoder.decoded,
      self.width, self.height,
      self.frames, self.format,
    )

    get_media().baseline.update_reference(
      bitrate = bitrate, context = self.refctx)

    try:
      if "vbr" == self.rcmode:
        assert(self.minrate * 0.75 <= bitrate <= self.maxrate * 1.10)
    except Exception as e:
      slash.logger.warn(str(e))

    try:
      get_media().baseline.check_psnr(psnr = psnr, context = self.refctx)
    except Exception as e:
      slash.logger.warn(str(e))

    self.datapoints.append([round(bitrate, 4), round(psnr[3], 4)])

  def check_bitrate(self):
    pass

@slash.requires(*platform.have_caps("encode", "avc"))
class AVCEncoderTest(AVCEncoderBaseTest):
  def before(self):
    super().before()
    vars(self).update(
      caps      = platform.get_caps("encode", "avc"),
      lowpower  = 0,
    )

@slash.requires(*platform.have_caps("vdenc", "avc"))
class AVCEncoderLPTest(AVCEncoderBaseTest):
  def before(self):
    super().before()
    vars(self).update(
      caps      = platform.get_caps("vdenc", "avc"),
      lowpower  = 1,
    )

  def validate_caps(self):
    if vars(self).get("bframes", None) is not None and get_media()._get_gpu_gen() < 12.7:
      slash.logger.warn("ignoring bframes... not supported in lowpower mode")
      del vars(self)["bframes"]
    super().validate_caps()

class vbr(AVCEncoderTest):
  @slash.parametrize("case", [k for k,v in spec.items() if len(v.get("vbr", [])) > 0])
  def test_bdrate(self, case):
    vars(self).update(spec[case].copy())
    vars(self).update(case = case, rcmode = "vbr")
    self.bdrate()

class vbr_lp(AVCEncoderLPTest):
  @slash.parametrize("case", [k for k,v in spec.items() if len(v.get("vbr", [])) > 0])
  def test_bdrate(self, case):
    vars(self).update(spec[case].copy())
    vars(self).update(case = case, rcmode = "vbr")
    self.bdrate()

class cqp(AVCEncoderTest):
  @slash.parametrize("case", [k for k,v in spec.items() if len(v.get("cqp", [])) > 0])
  def test_bdrate(self, case):
    vars(self).update(spec[case].copy())
    vars(self).update(case = case, rcmode = "cqp")
    self.bdrate()

class cqp_lp(AVCEncoderLPTest):
  @slash.parametrize("case", [k for k,v in spec.items() if len(v.get("cqp", [])) > 0])
  def test_bdrate(self, case):
    vars(self).update(spec[case].copy())
    vars(self).update(case = case, rcmode = "cqp")
    self.bdrate()

