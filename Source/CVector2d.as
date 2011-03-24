package
{
	public class CVector2d
	{
		public var m_x:Number;
		public var m_y:Number;
		
		public function CVector2d(xVal:Number,yVal:Number)
		{
			m_x = xVal;
			m_y = yVal;
		}
		
		public function SetPos(xVal:Number,yVal:Number)
		{
			m_x = xVal;
			m_y = yVal;
		}
		
		public function Length():Number
		{
			return (Math.sqrt(m_x*m_x + m_y*m_y));
		}
		
		public function DotProduct(vect:CVector2d):Number
		{
			return (vect.m_x*m_x + vect.m_y*m_y);
		}
		
		public function Perp():CVector2d
		{
			var perp:CVector2d = new CVector2d(-m_y,m_x);
			return perp;
		}
		
		public function Distance(vect:CVector2d):Number
		{
			var dx:Number = vect.m_x - m_x;
			var dy:Number = vect.m_y - m_y;
			
			return (Math.sqrt(dx*dx + dy*dy));
		}
		
		public function AddVector(vect:CVector2d):void
		{
			m_x += vect.m_x;
			m_y += vect.m_y;
		}
		
		public function MultiplyWithScalar(num:Number):void
		{
			m_x *= num;
			m_y *= num;
		}
		
		public function Zero():void
		{
			m_x = 0.0;
			m_y = 0.0;
		}
		
		public function IsZero():Boolean
		{
			return ((m_x*m_x + m_y*m_y) < 0.00001);
		}
		
	}
}