use Crawler::Base -strict;
use Test::More qw(no_plan);

BEGIN{
    use_ok('Crawler::Parser::RSS');
}

my $rss = Crawler::Parser::RSS->new();
for my $e($rss->parse( do{ local $/; <DATA> } )->each){
    is(defined $e->title,1,'test rss title result');
    is(defined $e->link,1,'test rss link');
    is(defined $e->desc,1,'test desc content');
    is(defined $e->content,1,'test post content ');
}
__DATA__
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
	>

<channel>
	<title>买个便宜货、美国便宜货</title>
	<atom:link href="http://www.mgpyh.com/feed" rel="self" type="application/rss+xml" />
	<link>http://www.mgpyh.com</link>
	<description>有态度的推荐,海外购,转运,海淘,mgpyh.com,Amazon便宜货,亚马逊便宜货,转运,海外直邮,优惠券</description>
	<lastBuildDate>Sun, 02 Jun 2013 02:26:45 +0000</lastBuildDate>
	<language>zh-CN</language>
	<sy:updatePeriod>hourly</sy:updatePeriod>
	<sy:updateFrequency>1</sy:updateFrequency>
	<generator>http://wordpress.org/?v=3.4.1</generator>
		<item>
		<title>凑单品：我的第一套世界经典绘本故事（小兔彼得+大象巴巴 彩图全注音·儿童启蒙版）￥9</title>
		<link>http://www.mgpyh.com/collect-items-my-first-set-of-the-worlds-classic-story-peter-rabbit-and-elephant-baba-color-full-phonetic-%c2%b7-children-enlightenment-version-rmb-9.html</link>
		<comments>http://www.mgpyh.com/collect-items-my-first-set-of-the-worlds-classic-story-peter-rabbit-and-elephant-baba-color-full-phonetic-%c2%b7-children-enlightenment-version-rmb-9.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 02:26:15 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[国内优惠]]></category>
		<category><![CDATA[图书]]></category>
		<category><![CDATA[小兔彼得]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82386</guid>
		<description><![CDATA[亚马逊中国此次图书49折活动非常适合买大部头书籍，对应京东商城则是1折秒杀，于是就有了下面的产品。 &#038;nbsp [...]]]></description>
			<content:encoded><![CDATA[<p>亚马逊中国此次<a href="http://www.mgpyh.com/shopping-tips-amazon-china-the-book-51-off-caps-attention-is-needed-to-buy-all-of.html" target="_blank"><strong>图书49折</strong></a>活动非常适合买大部头书籍，对应京东商城则是<a href="http://click.union.jd.com/JdClick/?unionId=18550&amp;t=1&amp;to=http://sale.jd.com/act/KU1Io2Dic6sfn.html" target="_blank"><strong>1折秒杀</strong></a>，于是就有了下面的产品。</p>
<p>&nbsp;</p>
<p>这套图书就没啥要说的了，小兔彼得、大象巴巴领衔，给小朋友带来原汁原味的大师级作品，三卷注音版，适合小盆友阅读。</p>
<p>&nbsp;</p>
<p><a href="http://click.union.jd.com/JdClick/?unionId=18550&amp;t=1&amp;to=http://item.jd.com/11218230.html" target="_blank"><strong>京东商城</strong></a>今日售价￥9元，钻石客户免运费，否则需要凑单到39元。</p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/collect-items-my-first-set-of-the-worlds-classic-story-peter-rabbit-and-elephant-baba-color-full-phonetic-%c2%b7-children-enlightenment-version-rmb-9.html/feed</wfw:commentRss>
		<slash:comments>2</slash:comments>
		</item>
		<item>
		<title>国行不错价格，罗技Logitech G600 时空裂痕特别版￥329送鼠标垫+颈枕</title>
		<link>http://www.mgpyh.com/logitech-logitech-g600-space-time-rift-special-edition-329-yuan-to-send-mouse-pad-neck-pillow.html</link>
		<comments>http://www.mgpyh.com/logitech-logitech-g600-space-time-rift-special-edition-329-yuan-to-send-mouse-pad-neck-pillow.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 02:19:18 +0000</pubDate>
		<dc:creator>curtain</dc:creator>
				<category><![CDATA[国内优惠]]></category>
		<category><![CDATA[数码产品]]></category>
		<category><![CDATA[Logitech G600]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82374</guid>
		<description><![CDATA[罗技G600外形十分大气，官方规格尺寸为118mm x 75mm x 41mm，重量达到133克，比较适合男性 [...]]]></description>
			<content:encoded><![CDATA[<p>罗技G600外形十分大气，官方规格尺寸为118mm x 75mm x 41mm，重量达到133克，比较适合男性用户。外壳使用了黑色磨砂处理的工艺，摩擦力较强，适于游戏玩家长时间使用，外形上也颇似一个手雷。</p>
<p>&nbsp;</p>
<p>参数方面，安华高S9800定制版本——S9808激光引擎，Aimel 32U2主控带来了全速USB响应，并且有1024K存储空间，使得G600可以存储3组包含所有按键设置，无需重新，带着鼠标，在别的电脑上就能用。</p>
<p>&nbsp;</p>
<p>特殊按键方面，除了左右按键以及纵横滚轮，滚轮下方还有两颗可编程键G7、G8，默认状态下G8可实现在不同的配置文档中切换，G7则是Shift + B组合键(wow中打开所有背包)，<strong>左侧设计了多达12个按钮</strong>，按键编号从G9延伸至G20，均可自定义宏按钮。</p>
<p>&nbsp;</p>
<p><a href="http://click.union.jd.com/JdClick/?unionId=18550&amp;t=1&amp;to=http://item.jd.com/846087.html" target="_blank"><strong>京东商城</strong></a>今日售价￥329元，主流B2C最低售价，感谢Curtain童鞋爆料。</p>
<p>&nbsp;</p>
<p><img src="http://ww2.sinaimg.cn/bmiddle/745a8c23gw1dxkgsvqibcj.jpg" alt="" width="440" height="554" /></p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/logitech-logitech-g600-space-time-rift-special-edition-329-yuan-to-send-mouse-pad-neck-pillow.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>Little Noses Saline Spray/Drops 儿童盐水滴鼻剂30ml＊6=$19.47或更低</title>
		<link>http://www.mgpyh.com/little-noses-saline-spraydrops.html</link>
		<comments>http://www.mgpyh.com/little-noses-saline-spraydrops.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 02:15:25 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[健康养生]]></category>
		<category><![CDATA[母婴产品]]></category>
		<category><![CDATA[Little Noses]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82381</guid>
		<description><![CDATA[Little Noses是美国一家儿童护理类非药物品牌，专门为儿童常见的不是症状提供解决方案。 &#160;  [...]]]></description>
			<content:encoded><![CDATA[<p>Little Noses是美国一家儿童护理类非药物品牌，专门为儿童常见的不是症状提供解决方案。</p>
<p>&nbsp;</p>
<p>这款儿童盐水滴鼻剂，原理上类似于成人使用的洗鼻器，瓶子采用特殊喷头设计: 喷头朝下, 可作滴剂使用; 喷头朝上, 捏动瓶身, 就能成为喷雾剂，当小朋友出现鼻塞等症状造成不适时，可以根据宝宝抵制情况适当选择滴或是喷，来缓解鼻塞不通。亦可缓解鼻腔干燥，以及寒冷带来的鼻腔不适 感。</p>
<p>&nbsp;</p>
<p>价格方面，Amazon今日30ml装共6瓶大包售价$19.47，<a href="http://www.amazon.com/gp/product/B001G7QWZ8/ref=as_li_ss_tl?ie=UTF8&amp;m=ATVPDKIKX0DER&amp;tag=hhuwtian-20&amp;linkCode=as2&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B001G7QWZ8" target="_blank"><strong>链接在此</strong></a>，追求价格极致可以选择<a href="http://www.mgpyh.com/advanced-course.html" target="_blank"><strong>Subscribe &amp; Save</strong></a>方式购买获取额外优惠。</p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/little-noses-saline-spraydrops.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>惊爆价，降$11，Neptune Krill Oil Gold海王星磷虾油 500 mg 120粒软胶囊 $23.56</title>
		<link>http://www.mgpyh.com/nutrigold-krill-gold-neptune-krill-oil.html</link>
		<comments>http://www.mgpyh.com/nutrigold-krill-gold-neptune-krill-oil.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 01:21:01 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[健康养生]]></category>
		<category><![CDATA[Neptune Krill Oil Gold]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82378</guid>
		<description><![CDATA[磷虾营养价值极高，是人们今天已经发现的含蛋白质最高的生物，蛋白质含量达百分之五十以上，而且还含有极为丰富的人体 [...]]]></description>
			<content:encoded><![CDATA[<div>
<div>
<p>磷虾营养价值极高，是人们今天已经发现的含蛋白质最高的生物，蛋白质含量达百分之五十以上，而且还含有极为丰富的人体组织所必需的氨基酸和维生素A。磷虾油取自磷虾，含有丰富<strong>Omega-3</strong>（其实Omega-3脂肪酸是一类的说法，最出名的是<strong>DHA、EPA</strong>两种成分，EPA对疏导清理心脏血管有重要作用，有效防止多种心血管疾病和炎症的发生，增强免疫力，而DHA则是有着补脑、健脑、提高视力、防止近视以及提高免疫力的作用）。</p>
<p>&nbsp;</p>
<p>同时，还含有一种名为<strong>Astaxanthin</strong>磷脂型<strong>虾青素</strong>的分子，在体内可与蛋白质结合而呈青、蓝色。有抗氧化、抗衰老、抗肿瘤、预防心脑血管疾病作用。磷虾油还含有丰富的维生素E、维生素A、虾青素、磷脂质、类黄酮和功能的强大的抗氧化剂。</p>
<p>&nbsp;</p>
<p>功能方面，则有保护神经细胞膜，增强注意力和记忆力、理解力；抗疲劳，积极情绪支持； 缓解痛风和类风湿关节炎 ； 抗自由基、延缓老化；提高免疫力；改善妇女经前不适症状等多种效果。每日早晚各服用1粒即可。</p>
<p>&nbsp;</p>
<p>Amazon今日售价$23.56，<a href="http://www.amazon.com/gp/product/B005YC0KQ8/ref=as_li_ss_tl?ie=UTF8&amp;tag=hhuwtian-20&amp;linkCode=as2&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B005YC0KQ8" target="_blank"><strong>链接在此</strong></a>，历史最低，<span style="color: #ff0000;"><strong>比去年11月推荐便宜了$11</strong></span>！发货重量不足1lb，建议合理凑单，不过考虑到磷虾油应该是我们介绍到现在营养价值最为丰富的产品了，也就还说得过去。营养成分表请参考<a href="http://nutrigold.com/Neptune-Krill-Oil-500" target="_blank"><strong>官网</strong></a>。</p>
<p>&nbsp;</p>
<p>PS：<a href="http://www.mgpyh.com/gymnema-gold-500mg-90-veggie-capsules.html" target="_blank"><strong>武靴叶萃取物</strong></a>价格小张，建议等待。</p>
<p>&nbsp;</p>
<p><img src="http://ww4.sinaimg.cn/bmiddle/745a8c23gw1dthauvonxvj.jpg" alt="" width="352" height="352" /></p>
</div>
</div>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/nutrigold-krill-gold-neptune-krill-oil.html/feed</wfw:commentRss>
		<slash:comments>2</slash:comments>
		</item>
		<item>
		<title>剃的是寂寞？PHILIPS飞利浦臻锋3D剃须刀 1290X 3D 顶级剃须刀$219-50</title>
		<link>http://www.mgpyh.com/philips-norelco-1290x-sensotouch-3d-electric-shaver.html</link>
		<comments>http://www.mgpyh.com/philips-norelco-1290x-sensotouch-3d-electric-shaver.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 01:17:41 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[美容化妆]]></category>
		<category><![CDATA[1290X 3D]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82376</guid>
		<description><![CDATA[Philips Norelco系列剃须刀，按照2D、3D区分档次，再依照有没有桶来区分定位。本款1290x/4 [...]]]></description>
			<content:encoded><![CDATA[<div>
<p>Philips Norelco系列剃须刀，按照2D、3D区分档次，再依照有没有桶来区分定位。本款1290x/40即是旗舰产品。</p>
<p>&nbsp;</p>
<p>从科技水平上来说，这货拥有飞利浦迄今为止最先进的剃须系统， SensoTouch 臻锋 3D 系统，GyroFlex 3D 智能贴合系统可无缝地跟踪您的每一个面部轮廓，并可通过其升级精确切剃刀头，在短短几个剃须来回间，剃掉每一根须发。</p>
<p>&nbsp;</p>
<p>自带锂电池一次充电可以提供高达60分钟的续航，高端人士不用浪费时间在充电上，带有自动Travel lock旅行锁功能，收纳后不会被误触激活引发尴尬，尤其在飞机上不会被当作terrorist，带有5级电量提示，支持全身水洗，支持全球电压。</p>
<p>&nbsp;</p>
<p>Amazon今日售价$219，<a href="http://www.amazon.com/gp/product/B006W2SZT8/ref=as_li_ss_tl?ie=UTF8&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B006W2SZT8&amp;linkCode=as2&amp;m=ATVPDKIKX0DER&amp;tag=hhuwtian-20" target="_blank"><strong>链接在此</strong></a>，购买前点击页面下方的click this coupon，将产品放入购物车后依然是219美元，没关系，继续填写地址计算，直到结算的最后一步，会自动使用$20的promotional balance变为169美元。海外购成本约1180元。<br />
需要注意的是，与<a href="http://126.am/bQeGg4" target="_blank"><strong>国内售价</strong></a>￥3599的版本带有清洗桶不同，美行1290X并没有清洗桶么，这类权贵用品，在<a href="http://www.chiphell.com/thread-382485-1-1.html" target="_blank"><strong>Chiphell</strong></a>上总会有人开箱，各位寂寞的大叔可以考虑烧个这货。</p>
<p>&nbsp;</p>
<p>PS：有的童鞋说要买<a href="http://www.amazon.com/gp/product/B006W2SYHQ/ref=as_li_ss_tl?ie=UTF8&amp;tag=hhuwtian-20&amp;linkCode=as2&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B006W2SYHQ" target="_blank"><strong>1250X</strong></a>，小编告诉你区别是什么：1250X带有清洁桶，不带1290的自动Travel lock旅行锁，续航时间要短，关键是最便宜时候卖过$165-50，现在贵太多。</p>
<p>&nbsp;</p>
<p><img src="http://ww1.sinaimg.cn/bmiddle/745a8c23gw1dxvo86yy55j.jpg" alt="" width="440" height="281" /></p>
<p>&nbsp;</p>
<p><img class="alignnone" src="http://ww2.sinaimg.cn/bmiddle/745a8c23jw1e59jh0sm0yj20h80faq59.jpg" alt="" width="440" height="390" /></p>
</div>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/philips-norelco-1290x-sensotouch-3d-electric-shaver.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>国内优惠：Tamron 腾龙 18-270mm F/3.5-6.3 60周年纪念版长焦C口￥2599，随心配有￥220元的小痰盂</title>
		<link>http://www.mgpyh.com/domestic-preference-60-anniversary-tamron-dragon-18-270mm-f3-5-6-3-commemorative-edition-telephoto-c-export.html</link>
		<comments>http://www.mgpyh.com/domestic-preference-60-anniversary-tamron-dragon-18-270mm-f3-5-6-3-commemorative-edition-telephoto-c-export.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 01:07:18 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[国内优惠]]></category>
		<category><![CDATA[数码产品]]></category>
		<category><![CDATA[腾龙 18-270mm]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82373</guid>
		<description><![CDATA[腾龙的B008E是一款所谓一镜走天下的大变焦产品，滤镜口径62mm的小巧体积下，重量也仅有450g，产品加入了 [...]]]></description>
			<content:encoded><![CDATA[<p>腾龙的B008E是一款所谓一镜走天下的大变焦产品，滤镜口径62mm的小巧体积下，重量也仅有450g，产品加入了腾龙自家的PZD 宁静波超声波马达，自动变焦时能够更快、更静音。</p>
<p>&nbsp;</p>
<p>搭载VC光学防抖装置，变焦全程范围内最短摄影距离0.49m、270mm端的最大摄影倍率1:3.8，可轻松拍摄特写作品，评测方面，可以参考<a href="http://www.dpreview.com/lensreviews/tamron_18-270_3p5-6p3_vc_n15/2" target="_blank"><strong>dprenew</strong></a>，虽然大边角一般画质都会一般，但是腾龙在这个价位上算是做到了出色。</p>
<p>&nbsp;</p>
<p>易迅网上海仓今日售价￥2599元，下方随心配小痰盂售价￥220元，小痰盂全新的零售价是580元左右，因此等于镜头又便宜了300元的样子，而且还有保修，不管你需不需要，都建议买回来。</p>
<p>&nbsp;</p>
<p><img class="alignnone" src="http://ww3.sinaimg.cn/bmiddle/745a8c23jw1e59j9jvuztj20iz0eztap.jpg" alt="" width="440" height="347" /></p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/domestic-preference-60-anniversary-tamron-dragon-18-270mm-f3-5-6-3-commemorative-edition-telephoto-c-export.html/feed</wfw:commentRss>
		<slash:comments>2</slash:comments>
		</item>
		<item>
		<title>促销活动：购Britax B-Ready Stroller童车，免费送B-Safe Infant Car Seat, Second Seat, or Bassinet安全座椅等</title>
		<link>http://www.mgpyh.com/buy-a-britax-b-ready-stroller-get-a-free-britax-b-safe-infant-car-seat-second-seat-or-bassinet.html</link>
		<comments>http://www.mgpyh.com/buy-a-britax-b-ready-stroller-get-a-free-britax-b-safe-infant-car-seat-second-seat-or-bassinet.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 01:01:40 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[母婴产品]]></category>
		<category><![CDATA[Britax B-Ready Stroller]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82371</guid>
		<description><![CDATA[Amazon正进行有趣的活动，购买活动页面中的B-Ready Stroller童车，即可免费获赠同品牌安全座椅 [...]]]></description>
			<content:encoded><![CDATA[<p>Amazon正进行有趣的活动，购买<a href="http://www.amazon.com/gp/feature.html/?ie=UTF8&amp;camp=1789&amp;creative=9325&amp;docId=1001088901&amp;linkCode=ur2&amp;plgroup=1&amp;tag=hhuwtian-20" target="_blank"><strong>活动页面</strong></a>中的B-Ready Stroller童车，即可免费获赠同品牌安全座椅/第二座椅/提篮等产品中的一样。</p>
<p>&nbsp;</p>
<p>明星产品，比如之前推荐过的<a href="http://www.mgpyh.com/britax-b-ready-stroller-has-25-coupon.html" target="_blank"><strong>B-Ready Stroller</strong></a>，可以看到涨价了，但是提篮木有涨价，两者叠加之后，由于免费得一个，因此实际上价格略有降低。</p>
<p>&nbsp;</p>
<p>国内麻麻的困难在于，两个大件沉重的运费以及可能产生的体积费，是否需要购买，自行权衡吧。</p>
<p>&nbsp;</p>
<p><img class="alignnone" src="http://ww4.sinaimg.cn/bmiddle/745a8c23jw1e59j2p0nghj20i40cmtap.jpg" alt="" width="440" height="306" /></p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/buy-a-britax-b-ready-stroller-get-a-free-britax-b-safe-infant-car-seat-second-seat-or-bassinet.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>限时抢购：PHILIPS 飞利浦46PFL5525/T3 46英寸全高清LED液晶电视￥3999，流光溢彩功能</title>
		<link>http://www.mgpyh.com/flash-sale-philips-philips-46pfl5525t3-46-inch-full-hd-led-lcd-tv-3999-yuan-ambilight-function.html</link>
		<comments>http://www.mgpyh.com/flash-sale-philips-philips-46pfl5525t3-46-inch-full-hd-led-lcd-tv-3999-yuan-ambilight-function.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 00:53:59 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[国内优惠]]></category>
		<category><![CDATA[家居生活]]></category>
		<category><![CDATA[46PFL5525/T3]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82369</guid>
		<description><![CDATA[46PFL5525/T3是飞利浦一款定位较高的46英寸电视，1080P分辨率，提供了多大4个HDMI接口，在这 [...]]]></description>
			<content:encoded><![CDATA[<p>46PFL5525/T3是飞利浦一款定位较高的46英寸电视，1080P分辨率，提供了多大4个HDMI接口，在这个价位不算常见。提供2x 10W扬声器，带有Lan接口。</p>
<p>&nbsp;</p>
<p>值得一提的是，电视具有飞利浦特有的流光溢彩智能影院系统，通过内置智能电路监测系统，实时监控屏幕两侧电视画面的色彩并同步变换灯光色彩与强度。</p>
<p>&nbsp;</p>
<p><a href="http://www.amazon.cn/gp/product/B00AV3U9DO/ref=as_li_ss_tl?ie=UTF8&amp;camp=536&amp;creative=3132&amp;creativeASIN=B00AV3U9DO&amp;linkCode=as2&amp;tag=hhuwtian18-23" target="_blank"><strong>Z秒杀</strong></a>今日售价￥3999元，考虑到这货本来就木有节能补贴，42寸售价3399元左右，46寸这个价格还算说得过去。</p>
<p>&nbsp;</p>
<p><img class="alignnone" src="http://g-ec4.images-amazon.com/images/G/28/hardline-asin/20130104-L0022-48.jpg" alt="" width="455" height="239" /></p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/flash-sale-philips-philips-46pfl5525t3-46-inch-full-hd-led-lcd-tv-3999-yuan-ambilight-function.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>国行不错价格，ASICS GEL LYTE-33 II 缓震跑鞋￥558-200</title>
		<link>http://www.mgpyh.com/asics-gel-lyte-33-ii-running-shoes.html</link>
		<comments>http://www.mgpyh.com/asics-gel-lyte-33-ii-running-shoes.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 00:47:12 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[Amazon deals]]></category>
		<category><![CDATA[GEL LYTE-33 II]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82367</guid>
		<description><![CDATA[ASICS的33系列被誉为“自然跑的革命”，这款NERVE33自然也不例外。 &#160; 本款产品配置了GE [...]]]></description>
			<content:encoded><![CDATA[<p>ASICS的33系列被誉为“自然跑的革命”，这款NERVE33自然也不例外。</p>
<p>&nbsp;</p>
<p>本款产品配置了GEL减震系统，配以SOLYTE中底结构更明显的改善了舒适性增加了缓冲效果；鞋子里面具有PHF（记忆海绵，根据不同脚型保证贴脚）；外底采用AHAR+超耐磨橡胶；以SOLYTE中底结构更明显的改善了舒适性增加了缓冲效果。</p>
<p>&nbsp;</p>
<p><a href="http://www.amazon.cn/gp/product/B00BQ9EG4K/ref=as_li_ss_tl?ie=UTF8&amp;camp=536&amp;creative=3132&amp;creativeASIN=B00BQ9EG4K&amp;linkCode=as2&amp;tag=hhuwtian18-23" target="_blank"><strong>亚马逊中国</strong></a>今日售价￥558元，结算输入优惠代码TB642SPP可以优惠200元，最终售价￥358元，考虑到美行大约$45的价格，亚马逊中国价格还行。</p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/asics-gel-lyte-33-ii-running-shoes.html/feed</wfw:commentRss>
		<slash:comments>4</slash:comments>
		</item>
		<item>
		<title>秒杀预告：9点29开秒，TOSHIBA 东芝 V7 恺乐高端系列 2.5英寸 1TB USB3.0 白色 移动硬盘，预计￥459</title>
		<link>http://www.mgpyh.com/notice-seckill-nine-twenty-nine-seconds-toshiba-toshiba-v7-caleb-high-end-series-of-2-5-inch-1tb-usb3-0-white-mobile-hard-disk-is-459.html</link>
		<comments>http://www.mgpyh.com/notice-seckill-nine-twenty-nine-seconds-toshiba-toshiba-v7-caleb-high-end-series-of-2-5-inch-1tb-usb3-0-white-mobile-hard-disk-is-459.html#comments</comments>
		<pubDate>Sun, 02 Jun 2013 00:38:39 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[数码产品]]></category>
		<category><![CDATA[TOSHIBA东芝]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82364</guid>
		<description><![CDATA[来自东芝的USB 3.0硬盘产品，V7 恺乐系列，内置2.5寸5400RPM硬盘，随机附带了Tuxera NT [...]]]></description>
			<content:encoded><![CDATA[<p>来自东芝的USB 3.0硬盘产品，V7 恺乐系列，内置2.5寸5400RPM硬盘，随机附带了Tuxera NTFS for MAC，网友通过HD Tunes等软件评测，实际跑分可以达到百兆以上，中规中矩。</p>
<p>&nbsp;</p>
<p><a href="http://www.amazon.cn/b/?_encoding=UTF8&amp;camp=536&amp;creative=3200&amp;ie=UTF8&amp;linkCode=ur2&amp;node=42450071&amp;tag=hhuwtian18-23" target="_blank"><strong>Z秒杀</strong></a>将在9点29分秒杀本款产品，预计售价是459元，由于带有了硬盘包+USB线，如果是这个价，还是可以考虑购入的。</p>
<p>&nbsp;</p>
<p>另外8点59分也有1折图书秒杀，值得关注。</p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/notice-seckill-nine-twenty-nine-seconds-toshiba-toshiba-v7-caleb-high-end-series-of-2-5-inch-1tb-usb3-0-white-mobile-hard-disk-is-459.html/feed</wfw:commentRss>
		<slash:comments>1</slash:comments>
		</item>
		<item>
		<title>6月2日Myhabit、Gilt、Ruelala、Ebay促销介绍</title>
		<link>http://www.mgpyh.com/in-june-2nd-myhabit-gilt-ruelala-ebay-promotional-introduction.html</link>
		<comments>http://www.mgpyh.com/in-june-2nd-myhabit-gilt-ruelala-ebay-promotional-introduction.html#comments</comments>
		<pubDate>Sat, 01 Jun 2013 16:11:03 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[限时抢购]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82360</guid>
		<description><![CDATA[飞利浦新玩意8项全能，Philips Norelco QG3360/42 多功能毛发修剪器又优惠了一点。 &#038;n [...]]]></description>
			<content:encoded><![CDATA[<p>飞利浦新玩意8项全能，Philips Norelco <a href="http://www.mgpyh.com/philips-norelco-qg336042-multigroom-plus-2.html" target="_blank"><strong>QG3360/42</strong></a> 多功能毛发修剪器又优惠了一点。</p>
<p>&nbsp;</p>
<p>活动A：<a href="http://www.ruelala.com/invite/mgpyh" target="_blank"><strong>Ruelala</strong></a>也是一家闪购网站，点击注册之后方可浏览商品，作为知名的闪购店铺，今日可关注Tommy Bahama服装，男女皆有。</p>
<p>&nbsp;</p>
<p>活动B：Myhabit是亚马逊旗下名品专卖网站，与Amazon账户是通用的，因此直接使用Amazon账户登录即可。每天晚上0点Myhabit将会更新今日的抢购（或者说闪购）商品：<a href="http://www.myhabit.com/#page=g&amp;dept=women&amp;ref=qd_nav_tab_women&amp;tag=hhuwtian-20" target="_blank"><strong>女装</strong></a>链接在此，<a href="http://www.myhabit.com/#page=g&amp;dept=men&amp;ref=qd_nav_tab_men&amp;tag=hhuwtian-20" target="_blank"><strong>男装</strong></a>链接在此，<a href="http://www.myhabit.com/#page=g&amp;dept=kids&amp;ref=qd_nav_tab_kids&amp;tag=hhuwtian-20" target="_blank"><strong>童装</strong></a>链接在此。</p>
<p>&nbsp;</p>
<p>今日的特色品牌是<a href="http://www.myhabit.com/#page=b&amp;dept=women&amp;sale=A1UPT6I0UFMRPB&amp;ref=qd_g_women_cur_1_A1UPT6I0UFMRPB_b&amp;tag=hhuwtian-20" target="_blank"><strong>Emporio Armani</strong></a>的女款太阳镜，至于骚年则可以考虑<a href="http://www.myhabit.com/#page=b&amp;dept=men&amp;sale=A1TRT7WX373VD1&amp;ref=qd_g_men_cur_0_A1TRT7WX373VD1_hero_b&amp;tag=hhuwtian-20" target="_blank"><strong>Gitman Blue</strong></a> by Gitman Bros衬衫。</p>
<p>&nbsp;</p>
<p>活动C：<a href="http://www.mgpyh.com/go/gilt/tumiinvite" target="_blank"><strong>Gilt.com</strong></a>（点击注册）是美国一家以“闪购”为主的B2C，类似于Myhabit，每日会上市一些精品，价格一般会低于同期市场价。今日关注各种品牌的<a href="http://www.mgpyh.com/25545-2/82360" target="_blank"><strong>Bras</strong></a>。</p>
<p>&nbsp;</p>
<p><img class="alignnone" src="http://ww3.sinaimg.cn/bmiddle/745a8c23jw1e593qxdf9kj20gt0bwdhi.jpg" alt="" width="440" height="311" /></p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/in-june-2nd-myhabit-gilt-ruelala-ebay-promotional-introduction.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>国内优惠：AHMAD TEA ASSAM TEA亚曼阿萨姆红茶250g ￥69.9，满399返100品类京券</title>
		<link>http://www.mgpyh.com/ahmad-tea-assam-tea-2.html</link>
		<comments>http://www.mgpyh.com/ahmad-tea-assam-tea-2.html#comments</comments>
		<pubDate>Sat, 01 Jun 2013 15:46:10 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[国内优惠]]></category>
		<category><![CDATA[食品]]></category>
		<category><![CDATA[Ahmad Tea]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82356</guid>
		<description><![CDATA[阿萨姆红茶，产印度东北阿萨姆喜马拉雅山麓的阿萨姆溪谷一带。当地日照强烈，需另种树为茶树适度遮蔽；由于雨量丰富， [...]]]></description>
			<content:encoded><![CDATA[<p>阿萨姆红茶，产印度东北阿萨姆喜马拉雅山麓的阿萨姆溪谷一带。当地日照强烈，需另种树为茶树适度遮蔽；由于雨量丰富，因此促进热带 性的阿萨姆大叶种茶树蓬勃发育。</p>
<p>&nbsp;</p>
<p>饮用方面，可纯品或视喜好添加些许牛奶，糖或蜂蜜增添不同风味。 <a href="http://www.amazon.cn/gp/product/B006I0315C/ref=as_li_ss_tl?ie=UTF8&amp;camp=536&amp;creative=3132&amp;creativeASIN=B006I0315C&amp;linkCode=as2&amp;tag=hhuwtian18-23" target="_blank"><strong>亚马逊中国</strong></a>、<a href="http://click.union.jd.com/JdClick/?unionId=18550&amp;t=1&amp;to=http://item.jd.com/799328.html" target="_blank"><strong>京东商城</strong></a>今日售价￥69.9元。</p>
<p>&nbsp;</p>
<p>但是京东满399返100品类京券，主流B2C最低售价，淘宝上有价格类似的，但大多在运费上做文章。</p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/ahmad-tea-assam-tea-2.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>LEGO &#8220;Mini-Figure&#8221; 8GB玩偶U盘$9.99</title>
		<link>http://www.mgpyh.com/classic-lego-mini-figure-8gb-flash-memory-drives.html</link>
		<comments>http://www.mgpyh.com/classic-lego-mini-figure-8gb-flash-memory-drives.html#comments</comments>
		<pubDate>Sat, 01 Jun 2013 15:30:39 +0000</pubDate>
		<dc:creator>mgpyhadmin</dc:creator>
				<category><![CDATA[数码产品]]></category>
		<category><![CDATA[Mini-Figure]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82347</guid>
		<description><![CDATA[Mini-Figure“迷你人偶国”是世界上人口最大的国家，迷你人偶的总人数超过了40亿。 &#160; 这款 [...]]]></description>
			<content:encoded><![CDATA[<p>Mini-Figure“迷你人偶国”是世界上人口最大的国家，迷你人偶的总人数超过了40亿。</p>
<p>&nbsp;</p>
<p>这款算是LEGO的算是周边产品，USB 2.0接口，<a href="http://www.mgpyh.com/25545-2/82347" target="_blank"><strong>链接在此</strong></a>，建议凑单带回，反正是凑单品，粉丝可以买一个回来收藏。</p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/classic-lego-mini-figure-8gb-flash-memory-drives.html/feed</wfw:commentRss>
		<slash:comments>0</slash:comments>
		</item>
		<item>
		<title>国内优惠：铁三角（audio-technica） ATH-XS5 运动耳机￥189</title>
		<link>http://www.mgpyh.com/iron-triangle-audio-technica-ath-xs5-hip-hop-extreme-sport-headphones-breathable-perspiration-resistant-cushion.html</link>
		<comments>http://www.mgpyh.com/iron-triangle-audio-technica-ath-xs5-hip-hop-extreme-sport-headphones-breathable-perspiration-resistant-cushion.html#comments</comments>
		<pubDate>Sat, 01 Jun 2013 15:14:50 +0000</pubDate>
		<dc:creator>curtain</dc:creator>
				<category><![CDATA[数码产品]]></category>
		<category><![CDATA[铁三角 ATH-XS5]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82328</guid>
		<description><![CDATA[铁三角（audio-technica） ATH-XS5是一款入门级别的耳机，所以适合人群是普通用户，平时听音乐 [...]]]></description>
			<content:encoded><![CDATA[<p>铁三角（audio-technica） ATH-XS5是一款入门级别的耳机，所以适合人群是普通用户，平时听音乐看电影神马的完全没压力。</p>
<p>&nbsp;</p>
<p>这款耳机号称街舞极限运动耳机，因为有双重紧固的头戴， 透气防汗耳垫配置防跌落、断线保护装置，然后外形做的比较潮。阻抗47 Ω、频率响应为10 ~ 22000 Hz，灵敏度100 dB/mW。</p>
<p>&nbsp;</p>
<p>京东今日售价￥189，<a href="http://p.yiqifa.com/c?s=5690dd3f&amp;w=430603&amp;c=254&amp;i=160&amp;l=0&amp;e=xu&amp;t=http://item.jd.com/784089.html" target="_blank"><strong>链接在此</strong></a>，主流B2C最低价，其他渠道基本都是260起步，所以价格来说还是不错的。有文艺白色，骚气红色，普通黑色三色可选。小易这次￥269，大家又可以去爆小易玩了。</p>
<p><img class="alignnone" src="http://img30.360buyimg.com/erpWareDetail/g6/M05/04/1C/rBEGF1DKgNwIAAAAAAGPUwTwz-gAAA9LQHMiugAAY9r376.jpg" alt="" width="405" height="286" /></p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/iron-triangle-audio-technica-ath-xs5-hip-hop-extreme-sport-headphones-breathable-perspiration-resistant-cushion.html/feed</wfw:commentRss>
		<slash:comments>1</slash:comments>
		</item>
		<item>
		<title>限时抢购：宝丽来Polaroid男款偏光太阳镜飞行员典藏款PD7788 ￥148</title>
		<link>http://www.mgpyh.com/flash-paragraphs-polaroid-polaroid-male-pilots-polarized-sunglasses-collection-new-parallels.html</link>
		<comments>http://www.mgpyh.com/flash-paragraphs-polaroid-polaroid-male-pilots-polarized-sunglasses-collection-new-parallels.html#comments</comments>
		<pubDate>Sat, 01 Jun 2013 14:57:53 +0000</pubDate>
		<dc:creator>朝歌</dc:creator>
				<category><![CDATA[服装鞋帽]]></category>
		<category><![CDATA[限时抢购]]></category>

		<guid isPermaLink="false">http://www.mgpyh.com/?p=82331</guid>
		<description><![CDATA[Polaroid宝丽莱（台湾称拍立得）公司于1937年由艾德温·兰德和乔治·威尔怀特所创立，也是偏光镜的创始品 [...]]]></description>
			<content:encoded><![CDATA[<p>Polaroid宝丽莱（台湾称拍立得）公司于1937年由艾德温·兰德和乔治·威尔怀特所创立，也是偏光镜的创始品牌之一。</p>
<p>&nbsp;</p>
<p>这个是老朋友了，经常出现，不过都在￥156这个线上，这次京东终于降价了，2色可选。这款之前MGPYH<a href="http://www.mgpyh.com/domestic-preference-7788-neutral-section-polaroid-polaroid-polarized-sunglasses%ef%bf%a5-198-50.html" target="_blank"><strong>曾经爆料</strong></a>过，镜片宽度64mm，鼻中宽度13mm，镜腿长度125mm（64-13-125）不过这个是升级版。</p>
<p>&nbsp;</p>
<p><a href="http://p.yiqifa.com/c?s=5690dd3f&amp;w=430603&amp;c=254&amp;i=160&amp;l=0&amp;e=xu&amp;t=http://www.jd.com/tuan/10868013-1005301894.html" target="_blank"><strong>京东团购</strong></a>今日售价￥148元，已经有2000多人购买，团购还有一天10小时结束。上次有个哥们吐槽抢了好多次没抢到，这次降价了，快拿吧。</p>
<p>&nbsp;</p>
<p><img class="alignnone" src="http://img30.360buyimg.com/popWaterMark/g10/M00/02/1D/rBEQWFEP5ewIAAAAAAN1ZnPLhakAAAkjAAA6lEAA3V-369.jpg" alt="" width="518" height="293" /></p>
]]></content:encoded>
			<wfw:commentRss>http://www.mgpyh.com/flash-paragraphs-polaroid-polaroid-male-pilots-polarized-sunglasses-collection-new-parallels.html/feed</wfw:commentRss>
		<slash:comments>3</slash:comments>
		</item>
	</channel>
</rss>

