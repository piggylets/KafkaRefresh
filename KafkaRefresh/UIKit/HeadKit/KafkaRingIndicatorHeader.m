/**
 * Copyright (c) 2016-present, K.
 * All rights reserved.
 *
 * e-mail:xorshine@icloud.com
 * github:https://github.com/xorshine
 *
 * This source code is licensed under the MIT license.
 */

#import "KafkaRingIndicatorHeader.h"
#import "KafkaCategories.h"
 
@implementation KafkaRingIndicatorHeader

- (void)setupProperties{
	[super setupProperties];
	[self.layer addSublayer:self.arcLayer];
	[self addSubview:self.indicator];
}

- (void)layoutSubviews{
	[super layoutSubviews];
	self.arcLayer.frame = CGRectMake(0, 0, self.width, self.height);
	self.indicator.center = CGPointMake(self.width/2., self.height/2.);
}

- (void)setThemeColor:(UIColor *)fillColor{
	if (super.themeColor == fillColor) {
		return;
	}
	[super setThemeColor:fillColor];
	self.arcLayer.ringFillColor = fillColor;
}

- (void)setAnimatedBackgroundColor:(UIColor *)animatedBackgroundColor{
	if (super.animatedBackgroundColor == animatedBackgroundColor) {
		return;
	}
	[super setAnimatedBackgroundColor:animatedBackgroundColor];
	self.arcLayer.ringBackgroundColor = animatedBackgroundColor;
}

- (void)kafkaDidScrollWithProgress:(CGFloat)progress max:(const CGFloat)max{ 
#define kOffset 0.7
	if (progress >= kOffset) {
		progress = (progress-kOffset)/(max - kOffset);
		[self.arcLayer setProgress:progress];
	}
}

- (void)kafkaRefreshStateDidChange:(KafkaRefreshState)state{
	[super kafkaRefreshStateDidChange:state];
	switch (state) {
		case KafkaRefreshStateNone:{
			[self.arcLayer setProgress:0];
			break;
		}
		case KafkaRefreshStateScrolling:
		case KafkaRefreshStateReady:{
			break;
		}
		case KafkaRefreshStateRefreshing:{
			[self.arcLayer startAnimating];
			self.arcLayer.hidden = YES;
			[self.indicator startAnimating];
			break;
		}
		case KafkaRefreshStateWillEndRefresh:{ 
			[self.arcLayer stopAnimating];
			[self.indicator stopAnimating];
			self.arcLayer.hidden = NO;
			break;
		}
	}
} 

- (KafkaArcLayer *)arcLayer{
	if (!_arcLayer) {
		_arcLayer = [KafkaArcLayer layer];
	}
	return _arcLayer;
}

- (UIActivityIndicatorView *)indicator{
	if (!_indicator) {
		_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_indicator.hidesWhenStopped = YES;
	}
	return _indicator;
}

@end
