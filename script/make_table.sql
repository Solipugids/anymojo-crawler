-- Create syntax for TABLE 'album'
CREATE TABLE `album` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `website_id` int(11) NOT NULL,
  `status` varchar(11) DEFAULT 'undo',
  `category` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `author` varchar(32) DEFAULT NULL,
  `company` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'album_index'
CREATE TABLE `album_index` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `website_id` int(11) NOT NULL,
  `status` varchar(11) DEFAULT NULL,
  `category` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'album_page'
CREATE TABLE `album_page` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `website_id` int(11) NOT NULL,
  `status` varchar(11) DEFAULT NULL,
  `category` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'api_test'
CREATE TABLE `api_test` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'undo',
  `website_id` int(10) DEFAULT NULL,
  `category` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'archive'
CREATE TABLE `archive` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `website_id` int(11) NOT NULL,
  `status` varchar(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'artist'
CREATE TABLE `artist` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `status` varchar(20) DEFAULT 'undo',
  `name` varchar(20) DEFAULT NULL,
  `website_id` int(11) NOT NULL,
  `category` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'artist_page'
CREATE TABLE `artist_page` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `website_id` int(11) NOT NULL,
  `status` varchar(11) DEFAULT NULL,
  `category` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'category'
CREATE TABLE `category` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'feeder'
CREATE TABLE `feeder` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `website_id` int(11) NOT NULL,
  `page_num` int(11) DEFAULT NULL,
  `status` varchar(11) DEFAULT NULL,
  `category` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'home'
CREATE TABLE `home` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT '',
  `website_id` int(11) DEFAULT NULL,
  `category` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'mp3'
CREATE TABLE `mp3` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` text,
  `artist_name` varchar(32) DEFAULT NULL,
  `artist_id` int(12) DEFAULT NULL,
  `location` varchar(255) DEFAULT '',
  `hq_location` varchar(255) DEFAULT '',
  `song_logo` varchar(255) DEFAULT '',
  `album_id` int(12) DEFAULT NULL,
  `album` varchar(255) DEFAULT NULL,
  `album_logo` varchar(255) DEFAULT NULL,
  `website_id` int(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'undo',
  `company` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `hot_num` int(20) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `lrc` varchar(255) DEFAULT NULL,
  `download_path` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `size` int(20) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'page'
CREATE TABLE `page` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` text NOT NULL,
  `page_num` int(11) NOT NULL,
  `website_id` int(11) NOT NULL,
  `status` varchar(11) DEFAULT NULL,
  `hot_num` int(11) DEFAULT NULL,
  `hot_max` int(11) DEFAULT NULL,
  `singer_name` varchar(40) DEFAULT NULL,
  `category` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'perl_blog'
CREATE TABLE `perl_blog` (
  `md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `source` varchar(255) NOT NULL DEFAULT '',
  `category` varchar(20) NOT NULL DEFAULT '',
  `img` text,
  `comment_times` int(20) DEFAULT NULL,
  `rating_times` int(20) DEFAULT NULL,
  `down` int(20) DEFAULT NULL,
  `up` int(20) DEFAULT NULL,
  `post_date` datetime DEFAULT NULL,
  `status` varchar(11) DEFAULT NULL,
  `share_count` int(20) DEFAULT NULL,
  `content` text,
  `title` varchar(255) DEFAULT NULL,
  `mall_link` varchar(255) DEFAULT NULL,
  `source_name` varchar(255) DEFAULT NULL,
  `author` varchar(20) DEFAULT NULL,
  `uid` int(20) DEFAULT NULL,
  PRIMARY KEY (`md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'song'
CREATE TABLE `song` (
  `name` varchar(255) DEFAULT NULL,
  `author` varchar(30) DEFAULT NULL,
  `download` text,
  `publisher` varchar(20) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'undo',
  `website_id` int(11) DEFAULT NULL,
  `url` text,
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `album` varchar(255) DEFAULT NULL,
  `hot_num` int(11) DEFAULT NULL,
  `page_id` varchar(32) DEFAULT NULL,
  `artist_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'sp_info'
CREATE TABLE `sp_info` (
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) DEFAULT NULL,
  `buy_link` varchar(255) DEFAULT NULL,
  `preview_img` varchar(255) DEFAULT NULL,
  `modal_img` varchar(255) DEFAULT NULL,
  `sing_price` float DEFAULT NULL,
  `batch_price` float DEFAULT NULL,
  `seller_address` varchar(20) DEFAULT NULL,
  `rating` float DEFAULT NULL,
  `buy_times_per_month` int(11) DEFAULT NULL,
  `recent_buy_times` int(11) DEFAULT NULL,
  `comment_times` int(11) DEFAULT NULL,
  `shop_name` varchar(11) DEFAULT NULL,
  `style` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'task'
CREATE TABLE `task` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `type` varchar(11) NOT NULL DEFAULT '',
  `retry_times` int(11) DEFAULT NULL,
  `invoke_cmd` varchar(255) DEFAULT NULL,
  `status` varchar(11) NOT NULL DEFAULT '',
  `site_id` int(11) DEFAULT NULL,
  `size` int(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=540 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'task_detail'
CREATE TABLE `task_detail` (
  `url` varchar(255) NOT NULL DEFAULT '',
  `id` int(20) NOT NULL,
  `url_md5` varchar(32) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'tbl_result'
CREATE TABLE `tbl_result` (
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  `author` varchar(30) DEFAULT NULL,
  `album` varchar(255) DEFAULT NULL,
  `hot_num` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'website'
CREATE TABLE `website` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(11) DEFAULT NULL,
  `type` varchar(11) DEFAULT NULL,
  `region` varchar(11) DEFAULT NULL,
  `url` varchar(255) NOT NULL DEFAULT '',
  `desc` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'wp_post'
CREATE TABLE `wp_post` (
  `md5` varchar(32) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `source` varchar(255) NOT NULL DEFAULT '',
  `category` varchar(20) NOT NULL DEFAULT '',
  `price` varchar(20) DEFAULT NULL,
  `preview_img` text NOT NULL,
  `img` text,
  `comment_times` int(20) DEFAULT NULL,
  `rating_times` int(20) DEFAULT NULL,
  `down` int(20) DEFAULT NULL,
  `up` int(20) DEFAULT NULL,
  `collect` int(11) DEFAULT NULL,
  `buylink` text,
  `post_date` datetime DEFAULT NULL,
  `status` varchar(11) DEFAULT NULL,
  `share_count` int(20) DEFAULT NULL,
  `post_content` text,
  `title` varchar(255) DEFAULT NULL,
  `mall_link` varchar(255) DEFAULT NULL,
  `sj` varchar(255) DEFAULT NULL,
  `source_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'xiage'
CREATE TABLE `xiage` (
  `name` varchar(255) DEFAULT NULL,
  `author` varchar(30) DEFAULT NULL,
  `download` text,
  `publisher` varchar(20) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'undo',
  `website_id` int(11) DEFAULT NULL,
  `url` text,
  `url_md5` varchar(32) NOT NULL DEFAULT '',
  `album` varchar(255) DEFAULT NULL,
  `hot_num` int(11) DEFAULT NULL,
  `album_id` varchar(32) DEFAULT NULL,
  `size` int(20) DEFAULT NULL,
  `company` varchar(20) DEFAULT NULL,
  `composer` varchar(20) DEFAULT NULL,
  `songwriters` varchar(20) DEFAULT NULL,
  `style` varchar(20) DEFAULT NULL,
  `track` varchar(20) DEFAULT NULL,
  `rel_path` text,
  `description` text,
  `lyric` text,
  `album_logo` varchar(255) DEFAULT NULL,
  `rating` varchar(10) DEFAULT NULL,
  `title` varchar(20) DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `language` varchar(20) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `album_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`url_md5`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

