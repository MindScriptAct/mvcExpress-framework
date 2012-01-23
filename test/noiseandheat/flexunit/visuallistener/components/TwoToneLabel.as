package noiseandheat.flexunit.visuallistener.components
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * Copyright (C) 2011 David Wagner
     */
    public class TwoToneLabel
        extends Sprite
    {
        protected var _prefixA:String;
        protected var _postfixA:String;
        protected var _textA:String;

        protected var _prefixB:String;
        protected var _postfixB:String;
        protected var _textB:String;

        protected var field:TextField;

        protected var _maxWidth:int;

        public function TwoToneLabel(maxWidth:int, prefixA:String = "", postfixA:String = "", prefixB:String = "", postfixB:String = ""):void
        {
            mouseEnabled = false;
            mouseChildren = false;

            _maxWidth = maxWidth;

            _prefixA = prefixA || "";
            _textA = "";
            _postfixA = postfixA || "";

            _prefixB = prefixB || "";
            _textB = "";
            _postfixB = postfixB || "";

            field = new TextField();
            wordWrap = true;
            field.background = true;
            backgroundColor = 0xffffff;

            var tf:TextFormat = field.defaultTextFormat;
            tf.font = "Arial";
            tf.size = 14;

            field.defaultTextFormat = tf;

            addChild(field);
        }

        public function get backgroundColor():uint
        {
            return field.backgroundColor;
        }

        public function set backgroundColor(color:uint):void
        {
            field.backgroundColor = color;
        }

        public function get wordWrap():Boolean
        {
            return field.wordWrap;
        }

        public function set wordWrap(wrap:Boolean):void
        {
            field.wordWrap = wrap;
            if(wrap)
            {
                field.multiline = true;
            }
            else
            {
                field.multiline = false;
            }
        }

        protected function updateText():void
        {
            var fullText:String = _prefixA + _textA + _postfixA +
                                  _prefixB + _textB + _postfixB;
            field.width = int.MAX_VALUE;
            field.htmlText = fullText;

            field.width = field.textWidth + 5;

            if(!wordWrap)
            {
                field.width = _maxWidth;
            }
            else if(field.width > _maxWidth)
            {
                field.width = _maxWidth;
            }

            field.height = field.textHeight + 5;
        }

        public function setDecorationA(prefix:String, postfix:String):void
        {
            _prefixA = prefix || "";
            _postfixA = postfix || "";

            updateText();
        }

        public function setDecorationB(prefix:String, postfix:String):void
        {
            _prefixB = prefix || "";
            _postfixB = postfix || "";

            updateText();
        }

        protected function cleanText(text:String):String
        {
            var cleaned:String = text.replace(/\</g, "&lt;");
            cleaned = cleaned.replace(/\>/g, "&gt;");
            return cleaned;
        }

        public function setText(a:String, b:String):void
        {
            _textA = a || "";
            _textB = b || "";

            _textA = cleanText(_textA);
            _textB = cleanText(_textB);

            updateText();
        }
    }
}
