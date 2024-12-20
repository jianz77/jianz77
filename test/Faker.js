import faker from 'faker'
// 获取随机图片 URL
const imageUrl = faker.image.imageUrl(300,200, 'nature',true, true);
console.log(imageUrl);
